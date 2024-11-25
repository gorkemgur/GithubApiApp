//
//  UserSearchDatabaseModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift

final class UserSearchDatabaseModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var login: String
    @Persisted var name: String
    @Persisted var location: String?
    @Persisted var avatarURL: String
    @Persisted var email: String?
    @Persisted var accountCreatedAt: String?
    @Persisted var followersCount: Int
    @Persisted var followingCount: Int
    @Persisted var repositoryCount: Int
    @Persisted var company: String?
    @Persisted var repositories: List<RepositoryDatabaseModel>
    
    convenience init(from userModel: UserSearchModel) {
        self.init()
        self.id = userModel.id
        self.login = userModel.login
        self.name = userModel.name
        self.location = userModel.location
        self.avatarURL = userModel.avatarURL
        self.accountCreatedAt = userModel.accountCreatedAt
        self.followersCount = userModel.followersCount
        self.followingCount = userModel.followingCount
        self.repositoryCount = userModel.repositoryCount
        self.company = userModel.company
    }
}

extension UserSearchDatabaseModel {
    func convertToUserModel() -> UserSearchModel {
        return UserSearchModel(
            id: id,
            login: login,
            name: name,
            location: login,
            avatarURL: avatarURL,
            accountCreatedAt: accountCreatedAt,
            followersCount: followersCount,
            followingCount: followingCount,
            repositoryCount: repositoryCount)
    }
}
