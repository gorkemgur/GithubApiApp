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
    var userListPublisher: AnyPublisher<UserSearchModel, Never> { get }
    
    func saveUser(_ userModel: UserSearchModel) throws
    func fetchUser(with storageFetchOptions: StorageFetchOptions)
}

final class LocalStorageManager: LocalStorageService {
    private let realm: Realm
    private let userObserver = PassthroughSubject<UserSearchModel, Never>()
    
    var userListPublisher: AnyPublisher<UserSearchModel, Never> {
        userObserver.eraseToAnyPublisher()
    }
    
    init(configuration: Realm.Configuration = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)) {
        realm = try! Realm(configuration: configuration)
    }
    
    func saveUser(_ userModel: UserSearchModel) throws {
        do {
            try realm.write {
                let user = UserSearchDatabaseModel(from: userModel)
                realm.add(user, update: .modified)
                userObserver.send(userModel)
            }
        } catch {
            throw LocalStorageError.saveError(error)
        }
    }
    
    
    func fetchUser(with storageFetchOptions: StorageFetchOptions) {
        guard let userObject = realm.objects(UserSearchDatabaseModel.self).filter(storageFetchOptions.fetchRequest).first else {
            return
        }
        userObserver.send(userObject.convertToUserModel())
    }
}
