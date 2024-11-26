//
//  UserListViewModelTest.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 26.11.2024.
//

import XCTest
import Combine
@testable import GithubApiApp

final class UserListViewModelTest: XCTestCase {
    var sut: UserSearchListViewModel!
    var mockNetworkMonitoring: MockNetworkMonitoring!
    var mockNetworkManager: MockNetworkManager!
    var mockLocalStorage: MockLocalStorage!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockLocalStorage = MockLocalStorage()
        mockNetworkMonitoring = MockNetworkMonitoring()
        cancellables = Set<AnyCancellable>()
        sut = UserSearchListViewModel(
            networkService: mockNetworkManager,
            storageService: mockLocalStorage,
            networkMonitoringService: mockNetworkMonitoring)
    }
    
    private func loadJsonFile(fileName: String) -> Data? {
        let sampleFileUrl = Bundle(for: NetworkManagerTests.self).url(forResource: fileName, withExtension: "json")
        return try? Data(contentsOf: sampleFileUrl!)
    }
    
    override func tearDown() {
        mockLocalStorage = nil
        mockNetworkManager = nil
        mockNetworkMonitoring = nil
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    func testUserSearch() async throws {
        //Given
        var fetchedUser: UserSearchModel?
        var isConnectionAvailable: Bool?
        var networkError: NetworkError?
        var localStorageError: LocalStorageError?
        let expectation = XCTestExpectation(description: "Should Be Fetch User")
        mockNetworkManager.mockData = loadJsonFile(fileName: "userSampleJson")
        mockNetworkManager.shouldShowError = false
        mockLocalStorage.shouldFailSaveUser = false
        
        //When
        mockNetworkMonitoring.currentConnectionStatus
            .sink { isNetworkConnectionAvailable in
                isConnectionAvailable = isNetworkConnectionAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = true
        
        try await Task.sleep(nanoseconds: 1_000_000)
        
        if isConnectionAvailable == true {
            do {
                fetchedUser = try await self.mockNetworkManager.performRequest(UserSearchModel.self, with: MockEndpointEnum.mock)
                try mockLocalStorage.saveUser(fetchedUser!)
                try mockLocalStorage.fetchUser(with: .user(userName: fetchedUser!.login))
                expectation.fulfill()
            } catch {
                if let error = error as? LocalStorageError {
                    localStorageError = error
                } else if let error = error as? NetworkError {
                    networkError = error
                }
            }
        } else {
            XCTFail("Current Network Status Must Be True")
        }
        
        //Then
        XCTAssertEqual(isConnectionAvailable, true)
        XCTAssertTrue(mockLocalStorage.didSaveUserCalled, "After Network Fetch Must Be Called")
        XCTAssertTrue(mockLocalStorage.didFetchUserCalled, "After Local Storage Save Read From Local Storage")
        XCTAssertNotNil(fetchedUser, "Fetched User Must Be Not Empty")
        XCTAssertNil(networkError)
        XCTAssertNil(localStorageError)
    }
    
    func testUserSearchWithNetworkError() async throws {
        //Given
        var fetchedUser: UserSearchModel?
        var localeDataBaseUser: UserSearchModel?
        var isConnectionAvailable: Bool?
        var networkError: NetworkError?
        let mockUser = UserSearchTestModel.testUser
        mockNetworkManager.didRateLimitExceeded = true
        
        //When
        mockNetworkMonitoring
            .currentConnectionStatus
            .sink { isNetworkConnectionAvailable in
                isConnectionAvailable = isNetworkConnectionAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = true
        
        mockLocalStorage.userModelPublisher
            .sink { userModel in
                localeDataBaseUser = userModel
            }.store(in: &cancellables)
        
        try await Task.sleep(nanoseconds: 1_000_000)
        
        if isConnectionAvailable == true {
            do {
                fetchedUser = try await self.mockNetworkManager.performRequest(UserSearchModel.self, with: MockEndpointEnum.mock)
                try mockLocalStorage.saveUser(fetchedUser!)
                XCTFail("Network Fetch Must Be Failed")
            } catch {
                if let error = error as? NetworkError {
                    try? mockLocalStorage.fetchUser(with: .user(userName: mockUser.login))
                    networkError = error
                }
            }
        } else {
            XCTFail("Internet Connection Must Be Changed To True")
        }
        
        //Then
        XCTAssertEqual(isConnectionAvailable, true)
        XCTAssertNil(fetchedUser, "Fetched User Must Be Nil, We Expect Rate Limit Error")
        XCTAssertEqual(mockUser.id, localeDataBaseUser!.id)
        XCTAssertEqual(networkError, NetworkError.rateLimitExceeded)
        XCTAssertEqual(mockLocalStorage.didSaveUserCalled, false)
        XCTAssertEqual(mockLocalStorage.didFetchUserCalled, true, "Network Failed We Should Get Data From Repository")
    }
    
    
    func testUserFetchFromLocalStorageSuccess() {
        //Given
        let mockUser = UserSearchTestModel.testUser
        var isConnectionAvailale: Bool?
        var localStorageError: LocalStorageError?
        var fetchedUser: UserSearchModel?
        mockLocalStorage.shouldFailFetchUser = false
        
        //When
        mockNetworkMonitoring
            .currentConnectionStatus
            .sink { isNetworkConnectionAvailable in
                isConnectionAvailale = isNetworkConnectionAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = false
        
        mockLocalStorage.userModelPublisher
            .sink { userModel in
                fetchedUser = userModel
            }.store(in: &cancellables)
        
        if isConnectionAvailale == true {
            XCTFail("Network Connection Must Be Unavaiable")
        } else {
            do {
                try mockLocalStorage.fetchUser(with: .user(userName: mockUser.login))
            } catch {
                if let error = error as? LocalStorageError {
                    localStorageError = error
                }
            }
        }
        
        //Then
        XCTAssertFalse(isConnectionAvailale!, "Internet Connection Must Be Unavailable, We Will Fetch Data From Storage")
        XCTAssertNil(localStorageError, "LocalStorageError Must Be Nil, We Have User Data")
        XCTAssertEqual(mockUser.id, fetchedUser!.id)
        XCTAssertTrue(mockLocalStorage.didFetchUserCalled, "Should Be Called fetchUser If There Is No Internet Connection")
    }
    
    
    func testUserFetchFromLocalStorageFail() {
        //Given
        let mockUser = UserSearchTestModel.testUser
        var isConnectionAvailale: Bool?
        var localStorageError: LocalStorageError?
        var fetchedUser: UserSearchModel?
        mockLocalStorage.shouldFailFetchUser = true
        
        //When
        mockNetworkMonitoring
            .currentConnectionStatus
            .sink { isNetworkConnectionAvailable in
                isConnectionAvailale = isNetworkConnectionAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = false
        
        mockLocalStorage.userModelPublisher
            .sink { userModel in
                XCTFail("User Should Not Be Fetched")
                fetchedUser = userModel
            }.store(in: &cancellables)
        
        if isConnectionAvailale == true {
            XCTFail("Network Connection Must Be Unavaiable")
        } else {
            do {
                try mockLocalStorage.fetchUser(with: .user(userName: mockUser.login))
            } catch {
                if let error = error as? LocalStorageError {
                    localStorageError = error
                }
            }
        }
        
        //Then
        XCTAssertFalse(isConnectionAvailale!, "Internet Connection Must Be Unavailable, We Will Fetch Data From Storage")
        XCTAssertNil(fetchedUser, "LocalStorageError Must Be Nil, We Have User Data")
        XCTAssertNotNil(localStorageError)
        XCTAssertEqual(localStorageError, LocalStorageError.fetchError)
        XCTAssertNil(fetchedUser, "Uer Must Be Nil, We Receive LocalStorage Error")
        XCTAssertTrue(mockLocalStorage.didFetchUserCalled, "Should Be Called fetchUser If There Is No Internet Connection")
    }
    
    func testNetworkMonitoringSuccess() {
        //Given
        var networkStatusAvailable: Bool?
        
        //When
        mockNetworkMonitoring.currentConnectionStatus
            .sink { isNetworkValueAvailable in
                networkStatusAvailable = isNetworkValueAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = true
        
        //Then
        XCTAssertNotNil(networkStatusAvailable)
        XCTAssertEqual(networkStatusAvailable, true)
    }
    
    func testNetworkMonitoringFailed() {
        //Given
        var networkStatusAvailable: Bool?
        
        //When
        mockNetworkMonitoring.currentConnectionStatus
            .sink { isNetworkValueAvailable in
                networkStatusAvailable = isNetworkValueAvailable
            }.store(in: &cancellables)
        mockNetworkMonitoring.isNetworkConnectionAvailable = true
        
        //Then
        XCTAssertNotNil(networkStatusAvailable)
        XCTAssertNotEqual(networkStatusAvailable, false)
    }

}

fileprivate enum MockEndpointEnum: Endpoint {
    case mock
    
    var path: String {
        ""
    }
    
    var httpMethod: GithubApiApp.HTTPMethod {
        .post
    }
    
    var baseURL: String {
        "test.com"
    }
    
    
}
