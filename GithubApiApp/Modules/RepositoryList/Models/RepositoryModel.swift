//
//  RepositoryModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

struct RepositoryModel: Decodable, Equatable, Identifiable {
    let id: Int
    let owner: RepositoryOwnerModel?
    let repositoryDescription: String?
    let repositoryName: String
    let repositoryURL: String
    let isForked: Bool
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, owner
        case isForked = "fork"
        case repositoryDescription = "description"
        case repositoryName = "name"
        case repositoryURL = "html_url"
        case createdDate = "created_at"
    }
    
    static func == (lhs: RepositoryModel, rhs: RepositoryModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct RepositoryOwnerModel: Decodable {
    let id: Int
    let login: String
    let avatarURL: String
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
    }
}

extension RepositoryModel {
    static var mockData: Self {
        .init(
            id: 0, 
            owner: 
                RepositoryOwnerModel(
                    id: UserSearchModel.mockUser.id,
                    login: UserSearchModel.mockUser.login,
                    avatarURL: UserSearchModel.mockUser.avatarURL),
            repositoryDescription: "",
            repositoryName: "Github Api App",
            repositoryURL: "https://www.google.com",
            isForked: Bool.random(),
            createdDate: "23.08.1990")
    }
}
