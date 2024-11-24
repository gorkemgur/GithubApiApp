//
//  PreviewLocalStorageManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import Combine

final class PreviewLocalStorageManager: LocalStorageService {
    
    private let publisher = PassthroughSubject<UserSearchModel, Never>()
    
    var userListPublisher: AnyPublisher<UserSearchModel, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func saveUser(_ userModel: UserSearchModel) throws {
    }
    
    func fetchUser(with storageFetchOptions: StorageFetchOptions) {
    }
}
