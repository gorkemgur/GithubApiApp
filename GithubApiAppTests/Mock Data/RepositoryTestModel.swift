//
//  RepositoryTestModel.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import Foundation
@testable import struct GithubApiApp.RepositoryModel

struct RepositoryTestModel {
    static var testRepositories: [RepositoryModel] {
        var list: [RepositoryModel] = []
        for i in 0...5 {
            list.append(
                RepositoryModel(
                    id: i,
                    owner: RepositoryOwnerTestModel.testModel,
                    repositoryDescription: "Test Description",
                    repositoryName: "Test Repository Name",
                    repositoryURL: "",
                    isForked: false,
                    createdDate: "25.11.2024")
            )
        }
        return list
    }
}
