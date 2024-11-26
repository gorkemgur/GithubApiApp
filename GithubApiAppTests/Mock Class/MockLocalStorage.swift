//
//  MockLocalStorage.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 26.11.2024.
//

import Foundation
import Combine
@testable import GithubApiApp

final class MockLocalStorage: LocalStorageService {
    
    @Published private(set) var userSubject = PassthroughSubject<UserSearchModel, Never>()
    
    @Published private(set) var repositoriesSubject = PassthroughSubject<[RepositoryModel], Never>()
    
    var userModelPublisher: AnyPublisher<UserSearchModel, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    var repositoryListPublisher: AnyPublisher<[RepositoryModel], Never> {
        repositoriesSubject.eraseToAnyPublisher()
    }
    
    private(set) var didSaveUserCalled: Bool = false
    private(set) var didFetchUserCalled: Bool = false
    var shouldFailSaveUser: Bool = false
    var shouldFailFetchUser: Bool = false
    
    private(set) var didSaveRepositoriesCalled: Bool = false
    private(set) var didFetchRepositoriesCalled: Bool = false
    var shouldFailSaveRepositories: Bool = false
    var shouldFailFetchRepositories: Bool = false
    
    func saveUser(_ userModel: GithubApiApp.UserSearchModel) throws {
        didSaveUserCalled = true
        
        if shouldFailSaveUser {
            throw LocalStorageError.saveError("Save User Error")
        }
    }
    
    func fetchUser(with storageFilterOptions: GithubApiApp.StorageFilterOptions) throws {
        didFetchUserCalled = true
        
        if shouldFailFetchUser {
            throw LocalStorageError.fetchError
        }
        
        userSubject.send(UserSearchTestModel.testUser)
    }
    
    func saveRepositories(with storageFilterOptions: GithubApiApp.StorageFilterOptions, repositories: [GithubApiApp.RepositoryModel]) throws {
        didSaveRepositoriesCalled = true
        
        if shouldFailSaveUser {
            throw LocalStorageError.saveError("Save Repositories Error")
        }
    }
    
    func fetchRepositories(with storageFilterOptions: GithubApiApp.StorageFilterOptions) throws {
        didFetchRepositoriesCalled = true
        
        if shouldFailSaveRepositories {
            throw LocalStorageError.fetchError
        }
        
        repositoriesSubject.send(RepositoryTestModel.testRepositories)
    }
    
    
}
