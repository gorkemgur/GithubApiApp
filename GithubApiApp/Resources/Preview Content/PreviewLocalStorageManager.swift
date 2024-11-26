//
//  PreviewLocalStorageManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import Combine
import RealmSwift

final class PreviewLocalStorageManager: LocalStorageService {
    
    private let userSubject = PassthroughSubject<UserSearchModel, Never>()
    private let repositoriesSubject = PassthroughSubject<[RepositoryModel], Never>()
    
    private let realm: Realm
    
    var userModelPublisher: AnyPublisher<UserSearchModel, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    init() {
        try! realm = Realm(configuration: Realm.Configuration(inMemoryIdentifier: "preview-realm", deleteRealmIfMigrationNeeded: true))
    }
    
    var repositoryListPublisher: AnyPublisher<[RepositoryModel], Never> {
        repositoriesSubject.eraseToAnyPublisher()
    }
    
    func saveUser(_ userModel: UserSearchModel) throws {
    }
    
    func fetchUser(with storageFilterOptions: StorageFilterOptions) {
    }
    
    func fetchRepositories(with storageFilterOptions: StorageFilterOptions) throws {
    }
    
    func saveRepositories(with storageFilterOptions: StorageFilterOptions, repositories: [RepositoryModel]) throws {
    }
}
