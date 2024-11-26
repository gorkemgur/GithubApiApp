//
//  LocalStorageManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift
import Combine

protocol LocalStorageService: AnyObject {
    var userModelPublisher: AnyPublisher<UserSearchModel, Never> { get }
    var repositoryListPublisher: AnyPublisher<[RepositoryModel], Never> { get }
    
    func saveUser(_ userModel: UserSearchModel) throws
    func fetchUser(with storageFilterOptions: StorageFilterOptions) throws
    
    func saveRepositories(with storageFilterOptions: StorageFilterOptions, repositories: [RepositoryModel]) throws
    func fetchRepositories(with storageFilterOptions: StorageFilterOptions) throws
}

final class LocalStorageManager: LocalStorageService {
    private let realm: Realm
    private let userModelSubject = PassthroughSubject<UserSearchModel, Never>()
    private let repositoryListSubject = PassthroughSubject<[RepositoryModel], Never>()
    
    private let defaultConfiguration: Realm.Configuration = {
        let configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemeVersion in
                if oldSchemeVersion < 1 {
                    // If insert new data model change scheme and do migrate operations here
                }
            }, deleteRealmIfMigrationNeeded: false)
        return configuration
    }()
    
    var userModelPublisher: AnyPublisher<UserSearchModel, Never> {
        userModelSubject.eraseToAnyPublisher()
    }
    
    var repositoryListPublisher: AnyPublisher<[RepositoryModel], Never> {
        repositoryListSubject.eraseToAnyPublisher()
    }
    
    init(configuration: Realm.Configuration? = nil) {
        do {
            realm = try Realm(configuration: configuration ?? defaultConfiguration)
        } catch {
            #if DEBUG
            fatalError("Relam Initializon Failed!")
            #else
            print("Realm Initialization Failed")
            #endif
        }
    }
    
    func saveUser(_ userModel: UserSearchModel) throws {
        do {
            try realm.write {
                let user = UserSearchDatabaseModel(from: userModel)
                realm.add(user, update: .modified)
            }
        } catch {
            throw LocalStorageError.saveError(error.localizedDescription)
        }
    }
    
    func fetchUser(with storageFilterOptions: StorageFilterOptions) throws {
        guard let userObject = realm.objects(UserSearchDatabaseModel.self).filter(storageFilterOptions.fetchRequest).first else {
            throw LocalStorageError.fetchError
        }
        userModelSubject.send(userObject.convertToUserModel())
    }
    
    func saveRepositories(with storageFilterOptions: StorageFilterOptions, repositories: [RepositoryModel]) throws {
        do {
            guard let repositoryOwner = realm.objects(UserSearchDatabaseModel.self).filter(storageFilterOptions.fetchRequest).first else {
                throw LocalStorageError.userNotFoundError
            }
            
            try realm.write {
                let repositoriesDatabaseModel = repositories.map { RepositoryDatabaseModel(from: $0) }
                realm.add(repositoriesDatabaseModel, update: .modified)
                
                repositoryOwner.repositories.append(objectsIn: repositoriesDatabaseModel)
            }
            
        } catch {
            throw LocalStorageError.saveError(error.localizedDescription)
        }
    }
    
    func fetchRepositories(with storageFilterOptions: StorageFilterOptions) throws {
        guard let repositoryOwner = realm.objects(UserSearchDatabaseModel.self).filter(storageFilterOptions.fetchRequest).first else {
            throw LocalStorageError.userNotFoundError
        }
        
        let sortedRepositoryList = repositoryOwner.repositories.sorted(byKeyPath: "isForked", ascending: true)
        
        let repositoriesModelList = Array(sortedRepositoryList.compactMap { repositoryDatabaseModel in
            return repositoryDatabaseModel.convertToRepositoryModel()
        })
        
        guard !repositoriesModelList.isEmpty else {
            throw LocalStorageError.repositoryNotFoundError
        }
        
        repositoryListSubject.send(repositoriesModelList)
    }
}
