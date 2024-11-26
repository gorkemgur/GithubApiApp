//
//  RepositoryDatabaseModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift

final class RepositoryDatabaseModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var repositoryName: String
    @Persisted var repositoryDescription: String
    @Persisted var repositoryURL: String
    @Persisted var isForked: Bool
    @Persisted var createdDate: String
    @Persisted(originProperty: "repositories") var owner: LinkingObjects<UserSearchDatabaseModel>
    
    
    convenience init(from repositoryModel: RepositoryModel) {
        self.init()
        self.id = repositoryModel.id
        self.repositoryName = repositoryModel.repositoryName
        self.repositoryDescription = repositoryModel.repositoryDescription ?? ""
        self.repositoryURL = repositoryModel.repositoryURL
        self.isForked = repositoryModel.isForked
        self.createdDate = repositoryModel.createdDate
    }
}

extension RepositoryDatabaseModel {
    func convertToRepositoryModel() -> RepositoryModel? {
        if let ownerModel = owner.first?.convertToUserModel() {
            return RepositoryModel(
                id: id,
                owner: RepositoryOwnerModel(id: ownerModel.id, login: ownerModel.login, avatarURL: ownerModel.avatarURL),
                repositoryDescription: repositoryDescription,
                repositoryName: repositoryName,
                repositoryURL: repositoryURL,
                isForked: isForked,
                createdDate: createdDate)
        }
        return nil
    }
}

