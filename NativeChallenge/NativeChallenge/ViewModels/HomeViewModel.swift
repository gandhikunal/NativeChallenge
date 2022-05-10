//
//  HomeViewModel.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func favouritesViewModelDidChange(_ viewModel: HomeViewModel)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    var favouritesViewModel: CarMakesViewModel = CarMakesViewModel() {
        didSet {
            delegate?.favouritesViewModelDidChange(self)
        }
    }
    
    var favouritesCount: Int {
        return favouritesViewModel.selectionCount()
    }
}
