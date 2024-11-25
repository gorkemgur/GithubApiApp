//
//  UserSearchTestModel.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import Foundation
@testable import struct GithubApiApp.UserSearchModel

struct UserSearchTestModel {
    static var testUser: UserSearchModel {
        .init(
            id: 1,
            login: "TestUser",
            name: "Test User",
            avatarURL: "",
            followersCount: 10,
            followingCount: 10,
            repositoryCount: 5)
    }
}


