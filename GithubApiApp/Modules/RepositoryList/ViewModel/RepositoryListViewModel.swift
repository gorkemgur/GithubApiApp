//
//  RepositoryListViewModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

fileprivate enum PaginationConstants {
    static let perPage = 10
}

import Foundation
import NetworkMonitoring
import Combine

final class RepositoryListViewModel: ObservableObject {
    private let networkService: NetworkService
    private let storageService: LocalStorageService
    private let networkMonitoringService: NetworkMonitorService
    private let repositoryOwnerModel: UserSearchModel
    
    private var cancellables: Set<AnyCancellable>
    private var currentTask: Task<Void, Never>?
    private var hasPendingRequest = false
    private var currentPage = 1
    private var totalRepositories = 0
    
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var repositories: [RepositoryModel] = []
    @Published private(set) var isNetworkConnectionAvailable = false {
        didSet {
            if hasPendingRequest {
                if currentPage != 1 {
                    loadNextPage()
                } else {
                    fetchRepositories()
                }
            }
        }
    }
    @Published var errorMessage: String = ""
    
    init(
        networkService: NetworkService,
        storageService: LocalStorageService,
        networkMonitoringService: NetworkMonitorService,
        repositoryOwnerModel: UserSearchModel ) {
            self.networkService = networkService
            self.storageService = storageService
            self.networkMonitoringService = networkMonitoringService
            self.repositoryOwnerModel = repositoryOwnerModel
            self.cancellables = Set<AnyCancellable>()
            self.totalRepositories = repositoryOwnerModel.repositoryCount
            setupObservers()
        }
    
    
    private func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    deinit {
        cancellables.removeAll()
        cancelCurrentTask()
    }
}


//MARK: - SearchText And Network Monitoring Observers
extension RepositoryListViewModel {
    private func setupObservers() {
        networkMonitoringService
            .currentConnectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasNetworkConnection in
                self?.isNetworkConnectionAvailable = hasNetworkConnection
            }.store(in: &cancellables)
        
        storageService
            .repositoryListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                guard let self = self else { return }
                handleNewRepositories(newRepositories: repositories)
            }.store(in: &cancellables)
        
    }
    
    private func handleNewRepositories(newRepositories: [RepositoryModel]) {
        if repositories.isEmpty {
            repositories = newRepositories
        } else {
            newRepositories.forEach { repository in
                if !repositories.contains(where: { $0.id == repository.id}) {
                    repositories.append(repository)
                }
            }
        }
    }
}

//MARK: - LocalStorage Functions
extension RepositoryListViewModel {
    private func saveRepositoriesToLocalStorage(repositories: [RepositoryModel]) {
        do {
            try storageService.saveRepositories(with: .repositories(ownerId: repositoryOwnerModel.id), repositories: repositories)
            loadRepositoriesFromStorage()
        } catch {
            if let storageError = error as? LocalStorageError {
                self.viewState = .showEmptyView
                print(storageError.errorDescription)
            }
        }
    }
    
    private func loadRepositoriesFromStorage() {
        do {
            try storageService.fetchRepositories(with: .repositories(ownerId: repositoryOwnerModel.id))
        } catch {
            if let storageError = error as? LocalStorageError {
                self.viewState = .showEmptyView
                print(storageError.errorDescription)
                if case .repositoryNotFoundError = storageError {
                    errorMessage = storageError.errorDescription
                }
            }
        }
    }
}

//MARK: - Nework Request
extension RepositoryListViewModel {
    
    func getRepositories() {
        #warning("NetworkMonitor Should Be Refactor First Value Always Come False, it's not good solution")
        if isNetworkConnectionAvailable {
            fetchRepositories()
        } else {
            loadRepositoriesFromStorage()
        }
    }
    
    private func fetchRepositories() {
        cancelCurrentTask()
        currentTask = Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                try Task.checkCancellation()
                self.viewState = .showLoading
                defer {
                    self.viewState = .hideLoading
                    self.hasPendingRequest = false
                }
                let searchRepositoryEndpoint = RepositoriesSearchEndpoint.getRepositories(userName: repositoryOwnerModel.login, page: currentPage, perPage: PaginationConstants.perPage)
                let repositoriesModel = try await networkService.performRequest([RepositoryModel].self, with: searchRepositoryEndpoint)
                self.saveRepositoriesToLocalStorage(repositories: repositoriesModel)
            } catch {
                if let networkError = error as? NetworkError {
                    self.viewState = .showEmptyView
                    print(networkError.errorDescription)
                }
            }
            
        }
    }
    
    func loadNextPage() {
        guard viewState != .showLoading,
              repositories.count != totalRepositories,
              repositories.count >= PaginationConstants.perPage else {
            return
        }
        
        currentPage += 1
        
        if isNetworkConnectionAvailable {
            fetchRepositories()
        } else {
            hasPendingRequest = true
        }
    }
}
