//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by adithyan na on 6/9/25.
//

import XCTest

@testable import MovieApp

// A mock URLProtocol to return canned data
class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseError: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let data = MockURLProtocol.responseData ?? Data()
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    override func stopLoading() {}
}

final class MovieAppTests: XCTestCase {
    var service: TMDbService!
        var session: URLSession!
    
    override func setUpWithError() throws {
        
    }
   
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
