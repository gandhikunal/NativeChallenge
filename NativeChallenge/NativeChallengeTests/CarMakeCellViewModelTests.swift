//
//  CarMakeCellViewModelTests.swift
//  NativeChallengeTests
//
//  Created by KunalGandhi on 10.05.22.
//

import XCTest
@testable import NativeChallenge

class CarMakeCellViewModelTests: XCTestCase {
    
    private var cellViewModel: CarMakeCellViewModel!
    
    override func setUpWithError() throws {
        cellViewModel = CarMakeCellViewModel(make: CarMake(id: 22, name: "Tesla", isSelected: false))
    }

    override func tearDownWithError() throws {
        cellViewModel = nil
    }

    func test_get_name() throws {
        //Given: CarMakeCellViewModel is initialised with a CarMake see setUpWithError()
        //When: getName is used
        //Then: value returned should be the same the name of car make used for initialisation
        let name = cellViewModel.getName()
        XCTAssertEqual("Tesla", name)
    }

    func test_is_selected() throws {
        //Given: CarMakeCellViewModel is initialised with a CarMake see setUpWithError()
        //When: isSelected is used
        //Then: value returned should be false
        let selection = cellViewModel.isSelected()
        XCTAssertFalse(selection)
    }
    
    func test_get_id() {
        //Given: CarMakeCellViewModel is initialised with a CarMake see setUpWithError()
        //When: getId is used
        //Then: value returned should be the same the id of car make used for initialisation
        let id = cellViewModel.getId()
        XCTAssertEqual(22, id)
    }
    
    func test_modify_selection() {
        //Given: CarMakeCellViewModel is initialised with a CarMake see setUpWithError()
        //When: isSelected is used
        //Then: value returned should be false
        var selection = cellViewModel.isSelected()
        XCTAssertFalse(selection)
        
        //Given: Car make selection is false
        //When: modifySelection is called with true
        //Then: isSelected should return true
        cellViewModel.modifySelection(to: true)
        selection = cellViewModel.isSelected()
        XCTAssertTrue(selection)
        
        //Given: Car make selection is true
        //When: modifySelection is called with false
        //Then: isSelected should return false
        cellViewModel.modifySelection(to: false)
        selection = cellViewModel.isSelected()
        XCTAssertFalse(selection)
    }
}
