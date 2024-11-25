//
//  LocalStorageTests.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import XCTest
@testable import GithubApiApp
import RealmSwift
import Combine

final class LocalStorageTests: XCTestCase {
    var sut: LocalStorageManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        sut = LocalStorageManager(configuration: Realm.Configuration(inMemoryIdentifier: "test-local-storage"))
        cancellables = Set<AnyCancellable>()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSaveUserSuccess() {
        //Given
        let mockUser = UserSearchModel.testUser
        var storageError: LocalStorageError?
        
        //When
        do {
            try sut.saveUser(mockUser)
        } catch {
            storageError = error as? LocalStorageError
        }
        
        //Then
        XCTAssertNil(storageError, "Save User Should Be Success")
    }
    
    func testFetchUserSuccess() {
        //Given
        let mockUser = UserSearchModel.testUser
        let expectation = XCTestExpectation(description: "Test User Fetch")
        var fetchedUser: UserSearchModel?
        try? sut.saveUser(mockUser)
        
        //When
        sut.userModelPublisher
            .sink { userSearchModel in
                fetchedUser = userSearchModel
                expectation.fulfill()
            }.store(in: &cancellables)
        try? sut.fetchUser(with: .user(userName: mockUser.login))
        
        //Then
        wait(for: [expectation], timeout: 1.2)
        XCTAssertEqual(fetchedUser?.login, mockUser.login)
    }
    
    func testFetchUserFailed() {
        //Given
        let mockUser = UserSearchModel.testUser
        let expectation = XCTestExpectation(description: "Failed Fetch User")
        var fetchUserError: LocalStorageError?
        try? sut.saveUser(mockUser)
        
        //When
        do {
            try sut.fetchUser(with: .repositories(ownerId: mockUser.followingCount))
        } catch {
            fetchUserError = error as? LocalStorageError
            expectation.fulfill()
        }
        
        //Then
        XCTAssertNotNil(fetchUserError, "Fetch User With Repositories NSPredicate This Should Be Fail")
        XCTAssertEqual(fetchUserError!.errorDescription, "Error Ocurred With Fetching Data")
    }
    
    func testSaveRepositoriesSuccess() {
        //Given
        let mockUser = UserSearchModel.testUser
        let mockRepositories = RepositoryModel.testRepositories
        try? sut.saveUser(mockUser)
        var storageError: LocalStorageError?
       
        //When
        do {
            try sut.saveRepositories(with: .repositories(ownerId: mockUser.id), repositories: mockRepositories)
        } catch {
            storageError = error as? LocalStorageError
        }
        
        //Then
        XCTAssertNil(storageError, "Save Repositories Should Be Success")
    }
    
    func testFetchRepositoriesSuccess() {
        //Given
        let mockUser = UserSearchModel.testUser
        let mockRepositories = RepositoryModel.testRepositories
        var fetchedRepositories: [RepositoryModel]?
        var fetchRepositoryError: LocalStorageError?
        let expectation = XCTestExpectation(description: "Repositores Should Be Fetched")
        try? sut.saveUser(mockUser)
        try? sut.saveRepositories(with: .repositories(ownerId: mockUser.id), repositories: mockRepositories)
        
        //When
        do {
            try sut.fetchRepositories(with: .repositories(ownerId: mockUser.id))
        } catch {
            if case LocalStorageError.repositoryNotFoundError = error {
                fetchRepositoryError = error as? LocalStorageError
            }
        }
        
        sut.repositoryListPublisher
            .sink { repositories in
                fetchedRepositories = repositories
                expectation.fulfill()
            }.store(in: &cancellables)
        
        try? sut.fetchRepositories(with: .repositories(ownerId: mockUser.id))
        
        //Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(fetchRepositoryError, "Repositories Should Be Exist")
        XCTAssertNotNil(fetchedRepositories)
        XCTAssertEqual(fetchedRepositories?.count, mockRepositories.count)
        XCTAssertTrue(fetchedRepositories?.first?.owner?.login == mockUser.login, "Repositores Should Be In RelationShip With Parent(Owner)")
    }
}


fileprivate extension UserSearchModel {
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

fileprivate extension RepositoryModel {
    static var testRepositories: [RepositoryModel] {
        var list: [RepositoryModel] = []
        for i in 0...5 {
            list.append(
                RepositoryModel(
                    id: i,
                    owner: RepositoryOwnerModel.testModel,
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

fileprivate extension RepositoryOwnerModel {
    static var testModel: RepositoryOwnerModel {
        .init(
            id: 1,
            login: "TestUser",
            avatarURL: "")
    }
}
