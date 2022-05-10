//
//  CarMakesViewModel.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

protocol CarMakesViewModelDelegate: AnyObject {
    func cellViewModelDidChange(_ viewmodel: CarMakesViewModel, at index: Int)
    func viewModelDidFetchCarMakesWithSuccess(_ viewmodel: CarMakesViewModel)
    func viewModelFetchCarMakesDidFinish(_ viewmodel: CarMakesViewModel, withError error: Error)
}
class CarMakesViewModel {
    
    weak var delegate: CarMakesViewModelDelegate?
    let dataProvider: CarMakesDataProvider
    private var dataFetched: Bool = false
    private var carMakeCellModels: [CarMakeCellViewModel] = []
    private var selectedIndices: Set<Int> = []
    
    init(dataProvider: CarMakesDataProvider = AppDataProvider()) {
        self.dataProvider = dataProvider
        dataProvider.carMakesProviderDelegate = self
    }
    
    func fetchCarMakes() {
        let _ = dataProvider.fetchCarMakes()
    }
    
    private func populateCarMakes(_ makes: [CarMake]) {
        var cellModels: [CarMakeCellViewModel] = []
        let selectedIds = getSelectionIds()
        for make in makes {
            let m = CarMakeCellViewModel(make: make)
            if selectedIds.contains(m.getId()) {
                m.modifySelection(to: true)
            }
            cellModels.append(m)
        }
        carMakeCellModels = cellModels
    }
    
    private func getSelectionIds() -> Set<Int> {
        var output: Set<Int> = []
        for idx in selectedIndices {
            output.insert(carMakeCellModels[idx].getId())
        }
        return output
    }
    
    func toggleCarMake(at index: Int) {
        guard index >= 0 && index < carMakeCellModels.count else { return }
        let model = carMakeCellModels[index]
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
            model.modifySelection(to: false)
        } else {
            selectedIndices.insert(index)
            model.modifySelection(to: true)
        }
        delegate?.cellViewModelDidChange(self, at: index)
    }
    
    func cellModel(at index: Int) -> CarMakeCellViewModel? {
        guard index >= 0 && index < carMakeCellModels.count else { return nil }
        return carMakeCellModels[index]
    }
    
    func selectionCount() -> Int {
        return selectedIndices.count
    }
    
    func totalCarMakes() -> Int {
        return carMakeCellModels.count
    }
}


extension CarMakesViewModel: CarMakesDataProviderDelegate {
    func fetchCarMakesDidFinish(_ dataprovider: CarMakesDataProvider, withResult result: Result<[CarMake], Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch result {
            case .success(let makes):
                self.populateCarMakes(makes)
                self.dataFetched = true
                self.delegate?.viewModelDidFetchCarMakesWithSuccess(self)
            case .failure(let error):
                self.delegate?.viewModelFetchCarMakesDidFinish(self, withError: error)
            }
        }
    }
}
