//
//  UserSearchModel.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

struct UserSearchModel: Decodable, Identifiable {
    let id: Int
    let login: String
    let name: String
    let location: String?
    let avatarURL: String
    let email: String?
    let accountCreatedAt: String?
    let followersCount: Int
    let followingCount: Int
    let repositoryCount: Int
    let company: String?
    
    enum CodingKeys: String, CodingKey {
        case id, login, email, location, company, name
        case avatarURL = "avatar_url"
        case followersCount = "followers"
        case followingCount = "following"
        case repositoryCount = "public_repos"
        case accountCreatedAt = "created_at"
    }
    
    init(
        id: Int,
        login: String,
        name: String,
        location: String? = nil,
        avatarURL: String,
        email: String? = nil,
        accountCreatedAt: String? = nil,
        followersCount: Int,
        followingCount: Int,
        repositoryCount: Int,
        company: String? = nil) {
        self.id = id
        self.login = login
        self.name = name
        self.location = location
        self.avatarURL = avatarURL
        self.email = email
        self.accountCreatedAt = accountCreatedAt
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.repositoryCount = repositoryCount
        self.company = company
    }
}

extension UserSearchModel {
    static var mockUser: Self {
        UserSearchModel(id: 10, login: "Mock User", name: "Mock User Name", avatarURL: "", email: "gorkem.gur@icloud.com", accountCreatedAt: "20.10.1999" ,followersCount: 10, followingCount: 19, repositoryCount: 20)
    }
}
