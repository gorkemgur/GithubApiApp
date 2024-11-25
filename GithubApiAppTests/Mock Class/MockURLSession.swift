//
//  MockURLSession.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 25.11.2024.
//

import Foundation
import XCTest

final class MockURLSession: URLProtocol {
    
    static var completionHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let completionHandler = MockURLSession.completionHandler else {
            XCTFail("Couldn't Found Request Handler")
            return
        }
        
        do {
            let (response, data) = try completionHandler(request)
            
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Request Failed With error: \(error)")
        }
    }
    
    
    override func stopLoading() {}
}
