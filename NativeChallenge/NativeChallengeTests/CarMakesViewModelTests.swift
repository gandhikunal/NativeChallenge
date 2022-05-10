//
//  CarMakesViewModelTests.swift
//  NativeChallengeTests
//
//  Created by KunalGandhi on 10.05.22.
//

import XCTest
@testable import NativeChallenge

class CarMakesDataProviderMock: CarMakesDataProvider {
    
    let makes: [CarMake]
    let error: NSError
    var carMakesEndPoint: URL = URL(string: "http://www.sample.url.not.used/for/tests")!
    var shouldProduceData: Bool = true
    
    init(makes: [CarMake], error: NSError) {
        self.makes = makes
        self.error = error
    }
    
    
    func fetchCarMakes() -> AnyCancelable? {
        if shouldProduceData {
            carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .success(makes))
        } else {
            carMakesProviderDelegate?.fetchCarMakesDidFinish(self, withResult: .failure(error))
        }
        return nil
    }
    
    var carMakesProviderDelegate: CarMakesDataProviderDelegate?
}

class CarMakesViewModelTests: XCTestCase {

    private var successExpectation: XCTestExpectation!
    private var failureExpectation: XCTestExpectation!
    private var toggleExpectation: XCTestExpectation!
    let makes = [CarMake(id: 1, name: "Ford", isSelected: false), CarMake(id: 2, name: "Honda", isSelected: false)]
    let error = NSError(domain: "test", code: 10, userInfo: nil)
    var mock: CarMakesDataProviderMock!
    var viewModel: CarMakesViewModel!
    
    override func setUpWithError() throws {
        mock = CarMakesDataProviderMock(makes: makes, error: error)
        viewModel = CarMakesViewModel(dataProvider: mock)
        mock.carMakesProviderDelegate = viewModel
        viewModel.delegate = self
        // Given: We have never fetched CarMakes
        XCTAssertEqual(viewModel.totalCarMakes(), 0)
    }
    
    func test_car_makes_count_when_fetch_fails() {
        // Given: See setUpWithError()
        // When: fetchData produces error
        // Then: carMakes cound should be zero
        mock.shouldProduceData = false
        viewModel.fetchCarMakes()
        failureExpectation = expectation(description: "Data Fetch should fail")
        wait(for: [failureExpectation], timeout: 10.0)
        XCTAssertEqual(viewModel.totalCarMakes(), 0)
    }
    
    func test_car_makes_count_when_fetch_succeeds() {
        // Given: See setUpWithError()
        // When: fetchData produces data
        // Then: carMakes count should not be zero
        mock.shouldProduceData = true
        viewModel.fetchCarMakes()
        successExpectation = expectation(description: "Data Fetch should succeed")
        wait(for: [successExpectation], timeout: 10.0)
        XCTAssertEqual(viewModel.totalCarMakes(), 2)
    }
    
    func test_favourite_selection_count_when_no_data_fetched() {
        // Given: See setUpWithError()
        // When: Data is not fetched
        // Then: Favourite Selection count must be zero
        XCTAssertEqual(viewModel.selectionCount(), 0)
    }
    
    func test_favourite_selection_count_when_data_fetched_no_record_selected() {
        // Given: See setUpWithError()
        // When: Data is fetched, and no record is selected
        // Then: Favourite Selection count must be one
        viewModel.fetchCarMakes()
        successExpectation = expectation(description: "Data Fetch should succeed")
        wait(for: [successExpectation], timeout: 10.0)
        XCTAssertEqual(viewModel.selectionCount(), 0)
    }
        
    func test_favourite_selection_count_when_data_fetched_one_record_selected() {
        // Given: See setUpWithError()
        // When: Data is fetched, and no record is selected
        // Then: Favourite Selection count must be one
        viewModel.fetchCarMakes()
        successExpectation = expectation(description: "Data Fetch should succeed")
        wait(for: [successExpectation], timeout: 10.0)
        toggleExpectation = XCTestExpectation(description: "Record should be toggled on")
        viewModel.toggleCarMake(at: 0)
        wait(for: [toggleExpectation], timeout: 10.0)
        XCTAssertEqual(viewModel.selectionCount(), 1)
    }
    
    func test_toggle_car_make() {
        // Given: See setUpWithError()
        // When: Data is fetched freshly, and the first record is selected
        // Then: First record must be in selected state, and selection count should be 1
        toggleExpectation = XCTestExpectation(description: "Record should be toggled on")
        viewModel.fetchCarMakes()
        successExpectation = expectation(description: "Data Fetch should succeed")
        wait(for: [successExpectation], timeout: 10.0)
        viewModel.toggleCarMake(at: 0)
        wait(for: [toggleExpectation], timeout: 10.0)
        let cellModel = viewModel.cellModel(at: 0)
        XCTAssertNotNil(cellModel)
        XCTAssertTrue(cellModel!.isSelected())
        XCTAssertEqual(viewModel.selectionCount(), 1)
        
        // Given: Data has been fetched, and the first record is selected
        // When: First record is again clicked upon
        // Then: First record must be in not selected state, and selection cound should be zero
        toggleExpectation = XCTestExpectation(description: "Record should be toggled off")
        viewModel.toggleCarMake(at: 0)
        wait(for: [toggleExpectation], timeout: 10.0)
        XCTAssertNotNil(cellModel)
        XCTAssertFalse(cellModel!.isSelected())
        XCTAssertEqual(viewModel.selectionCount(), 0)
    }
    
    func test_fetch_car_makes_with_error() {
        // Give: See setUpWithError()
        // When: dataProvider produces error
        // Then: failure delegate must be called
        mock.shouldProduceData = false
        viewModel.fetchCarMakes()
        failureExpectation = expectation(description: "Data Fetch shoudl fail")
        wait(for: [failureExpectation], timeout: 10.0)
    }
    
    func test_fetch_car_make_with_success() {
        // Give: See setUp()
        // When: dataProvider produces data
        // Then: success delegate must be called
        mock.shouldProduceData = true
        viewModel.fetchCarMakes()
        successExpectation = expectation(description: "Data Fetch should succeed")
        wait(for: [successExpectation], timeout: 10.0)
    }
}


extension CarMakesViewModelTests: CarMakesViewModelDelegate {

    func viewModelFetchCarMakesDidFinishWithSuccess(_ viewmodel: CarMakesViewModel) {
        successExpectation.fulfill()
    }
    
    func viewModelFetchCarMakesDidFinish(_ viewmodel: CarMakesViewModel, withError error: Error) {
        failureExpectation.fulfill()
    }
    
    func viewModelDidChangeCell(_ viewmodel: CarMakesViewModel, at index: Int) {
        toggleExpectation.fulfill()
    }

}

