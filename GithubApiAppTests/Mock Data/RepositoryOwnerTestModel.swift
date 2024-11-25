//
//  RepositoryOwnerTestModel.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import Foundation
@testable import struct GithubApiApp.RepositoryOwnerModel

struct RepositoryOwnerTestModel {
    static var testModel: RepositoryOwnerModel {
        .init(
            id: 1,
            login: "TestUser",
            avatarURL: "")
    }
}
