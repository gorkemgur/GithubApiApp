//
//  UserSearchListViewModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import Combine
import NetworkMonitoring

final class UserSearchListViewModel: ObservableObject {
    private let networkService: NetworkService
    private let storageService: LocalStorageService
    private let networkMonitoringService: NetworkMonitorService
    
    private var cancellables: Set<AnyCancellable>
    private var currentTask: Task<Void, Never>?
    private var hasPendingSearchRequest = false
    
    @Published var userSearchQueryText = ""
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var userModel: UserSearchModel? = nil
    @Published private(set) var isNetworkConnectionAvailable = false {
        didSet {
            if hasPendingSearchRequest && !userSearchQueryText.isEmpty {
                searchUser()
            }
        }
    }
    
    init(
        networkService: NetworkService,
        storageService: LocalStorageService,
        networkMonitoringService: NetworkMonitorService) {
            self.networkService = networkService
            self.storageService = storageService
            self.networkMonitoringService = networkMonitoringService
            self.cancellables = Set<AnyCancellable>()
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
extension UserSearchListViewModel {
    private func setupObservers() {
        $userSearchQueryText
            .debounce(
                for: .milliseconds(300),
                scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                guard !searchText.isEmpty else {
                    self.userModel = nil
                    self.hasPendingSearchRequest = false
                    return
                }
                if self.isNetworkConnectionAvailable {
                    self.searchUser()
                } else {
                    hasPendingSearchRequest = true
                    loadUserFromLocalStorage()
                }
            }.store(in: &cancellables)
        
        networkMonitoringService
            .currentConnectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasNetworkConnection in
                print(hasNetworkConnection)
                self?.isNetworkConnectionAvailable = hasNetworkConnection
            }.store(in: &cancellables)
        
        storageService
            .userListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSearchModel in
                guard let self = self else { return }
                self.userModel = userSearchModel
            }.store(in: &cancellables)
    }
}


//MARK: - Nework Request
extension UserSearchListViewModel {
    private func searchUser() {
        cancelCurrentTask()
        currentTask = Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                try Task.checkCancellation()
                self.viewState = .showLoading
                defer {
                    self.viewState = .hideLoading
                    self.hasPendingSearchRequest = false
                }
                let userSearchEnpoint = UserSearchEndpoint.searchUser(userName: userSearchQueryText)
                let userSearchModel = try await networkService.performRequest(UserSearchModel.self, with: userSearchEnpoint)
                self.saveUserToLocaStorage(userModel: userSearchModel)
            } catch {
                if let networkError = error as? NetworkError {
                    self.viewState = .showEmptyView
                    print(networkError.errorDescription)
                }
            }
        }
    }
}

//MARK: - Local Storage Functions
extension UserSearchListViewModel {
    private func saveUserToLocaStorage(userModel: UserSearchModel) {
        do {
            try storageService.saveUser(userModel)
            loadUserFromLocalStorage()
        } catch {
            if let storageError = error as? LocalStorageError {
                self.viewState = .showEmptyView
                print(storageError.errorDescription)
            }
        }
    }
    
    private func loadUserFromLocalStorage() {
        storageService.fetchUser(with: .user(userName: userSearchQueryText))
    }
}
