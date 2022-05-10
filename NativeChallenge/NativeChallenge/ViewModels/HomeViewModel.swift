//
//  HomeViewModel.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

class HomeViewModel {
    
    var carMakesViewModel: CarMakesViewModel = CarMakesViewModel()
    
    var favouritesCount: Int {
        return carMakesViewModel.selectionCount()
    }
    
}
