//
//  NativeChallengeTests.swift
//  NativeChallengeTests
//
//  Created by KunalGandhi on 09.05.22.
//

import XCTest
@testable import NativeChallenge

class MockNetworkDataProvider: NetworkDataProvider {
    
    let makes: [CarMake]
    let error: NetworkApiError
    var shouldProduceData: Bool = true
    
    init(makes: [CarMake], error: NetworkApiError) {
        self.makes = makes
        self.error = error
    }
    func data(from url: URL, completion: @escaping (Result<HTTPResponse, NetworkApiError>) -> ()) -> AnyCancelable? {
        if shouldProduceData {
            let data = try! JSONEncoder().encode(makes)
            completion(.success(HTTPResponse(httpResponse: nil, data: data)))
        } else {
            completion(.failure(error))
        }
        return nil
    }
}

class AppDataProviderTests: XCTestCase {
    
    private var successExpectation: XCTestExpectation!
    private var failureExpectation: XCTestExpectation!
    private var appDataProvider: AppDataProvider!
    private var mockDataProvider: MockNetworkDataProvider!
    let makes = [CarMake(id: 1, name: "Ford", isSelected: false), CarMake(id: 2, name: "Honda", isSelected: false)]
    let error = NetworkApiError.noDataReturned
    
    override func setUpWithError() throws {
        mockDataProvider = MockNetworkDataProvider(makes: makes, error: error)
        let nwManager = NetworkManager(networkDataProvider: mockDataProvider)
        appDataProvider = AppDataProvider(manager: nwManager)
        appDataProvider.carMakesProviderDelegate = self
        
    }
    func test_fetch_data_with_success() {
        // Given: We have never fetched CarMakes
        // When: fetchCarMakes() is called on appDataProvider, and network manager succeeds
        // Then: Result passed to appDataProvider in the delegate call back, should be of type success and must contain correct data
        successExpectation = expectation(description: "Delegate must be called with success")
        let _ = appDataProvider.fetchCarMakes()
        wait(for: [successExpectation], timeout: 10.0)
    }
    
    func test_fetch_data_with_failure() {
        // Given: We have never fetched CarMakes
        // When: fetchCarMakes() is called on appDataProvider, and network manager fails
        // Then: Result passed to appDataProvider in the delegate call back, should be of type failure
        failureExpectation = expectation(description: "Delegate must be called with failure")
        mockDataProvider.shouldProduceData = false
        let _ = appDataProvider.fetchCarMakes()
        wait(for: [failureExpectation], timeout: 10.0)
    }
    
}

extension AppDataProviderTests: CarMakesDataProviderDelegate {
    func fetchCarMakesDidFinish(_ dataprovider: CarMakesDataProvider, withResult result: Result<[CarMake], Error>) {
        switch result {
        case .success(let m):
            XCTAssertEqual(m, makes)
            successExpectation.fulfill()
        case .failure(_):
            failureExpectation.fulfill()
        }
    }
}
