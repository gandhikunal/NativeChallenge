//
//  CarMakeCellViewModel.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 10.05.22.
//

import Foundation

class CarMakeCellViewModel {
    
    private var make: CarMake
    init(make: CarMake) {
        self.make = make
    }
    
    func getName() -> String {
        return make.name
    }
    
    func isSelected() -> Bool {
        return make.isSelected
    }
    
    func modifySelection(to: Bool) {
        // Simply return if nothing has to be changed.
        if to == make.isSelected { return }
        let new = CarMake(id: make.id, name: make.name, isSelected: to)
        make = new
    }
    
    func getId() -> Int {
        return make.id
    }
}
