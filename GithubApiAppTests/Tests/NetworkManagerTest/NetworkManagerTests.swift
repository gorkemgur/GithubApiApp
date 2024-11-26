//
//  NetworkManagerTests.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import Foundation
import XCTest
@testable import GithubApiApp

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkService!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLSession.self]
        let urlSession = URLSession.init(configuration: configuration)
        sut = NetworkManager(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    private func loadJsonFile(fileName: String) -> Data? {
        let sampleFileUrl = Bundle(for: NetworkManagerTests.self).url(forResource: fileName, withExtension: "json")
        return try? Data(contentsOf: sampleFileUrl!)
    }
    
    func testFetchUserDataSuccess() async {
        //Given
        let userJsonSampleData = loadJsonFile(fileName: "userSampleJson")!
        var fetchedUser: UserSearchModel?
        var networkError: NetworkError?
        let userEndpoint = MockSearchEndpoint.successSearch
        let mockURL = userEndpoint.createURLRequest()?.url
        
        MockURLSession.completionHandler = { request in
            let response = HTTPURLResponse(url: mockURL!, statusCode: 200, httpVersion: nil, headerFields: ["Accept-Type": "application/json"])
            return (response, userJsonSampleData)
        }
        
        //When
        do {
            fetchedUser = try await sut.performRequest(UserSearchModel.self, with: userEndpoint)
        } catch {
            if let error = error as? NetworkError {
                networkError = error
            }
        }
        
        //Then
        XCTAssertNil(networkError)
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.login, "gorkemgur")
    }
    
    func testFetchUserDataFailed() async {
        //Given
        let userJsonSampleData = loadJsonFile(fileName: "userSampleJson")!
        var fetchedUser: UserSearchModel?
        var networkError: NetworkError?
        let userEndpoint = MockSearchEndpoint.invalidPathSearch
        let mockURL = userEndpoint.createURLRequest()?.url
        
        MockURLSession.completionHandler = { request in
            let response = HTTPURLResponse(url: mockURL!, statusCode: 200, httpVersion: nil, headerFields: ["Accept-Type": "application/json"])
            return (response, userJsonSampleData)
        }
        
        //When
        do {
            fetchedUser = try await sut.performRequest(UserSearchModel.self, with: userEndpoint)
        } catch {
            if let error = error as? NetworkError {
                networkError = error
            }
        }
        
        //Then
        XCTAssertNil(fetchedUser)
        XCTAssertNotNil(networkError, "Error Must Be Not Nil, Because urlRequest Path Is Invalid")
        XCTAssertEqual(networkError, NetworkError.invalidURL)
    }
    
    func testFetchRepositoriesDataSuccess() async {
        //Given
        let repositoriesJsonSampleData = loadJsonFile(fileName: "repositorySampleJson")!
        var fetchedRepositories: [RepositoryModel]?
        var networkError: NetworkError?
        let repositoryEndpoint = MockSearchEndpoint.successSearch
        let mockURL = repositoryEndpoint.createURLRequest()?.url
        
        MockURLSession.completionHandler = { request in
            let response = HTTPURLResponse(url: mockURL!, statusCode: 200, httpVersion: nil, headerFields: ["Accept-Type": "application/json"])
            return (response, repositoriesJsonSampleData)
        }
        
        //When
        do {
            fetchedRepositories = try await sut.performRequest([RepositoryModel].self, with: repositoryEndpoint)
        } catch {
            if let error = error as? NetworkError {
                networkError = error
            }
        }
        
        //Then
        XCTAssertNil(networkError)
        XCTAssertNotNil(fetchedRepositories, "Error Must Be Not Nil, Because urlRequest Path Is Invalid")
        XCTAssertEqual(fetchedRepositories?.count, 3)
        XCTAssertEqual(fetchedRepositories?.first?.owner?.login, "gorkemgur")
    }
}

fileprivate enum MockSearchEndpoint: Endpoint {
    case successSearch
    case invalidPathSearch
    
    var path: String {
        switch self {
        case .successSearch:
            return "/path"
        case .invalidPathSearch:
            return "path"
        }
    }
    
    var httpMethod: GithubApiApp.HTTPMethod {
        .get
    }
    
    var baseURL: String {
        return "test.com"
    }
}
