//
//  HomeViewController.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 09.05.22.
//

import UIKit

class HomeViewController: UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavourites))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = "Favourite Count \(Int.random(in: 0...500))"
        navigationItem.titleView = label
    }
    
    @objc func addFavourites() {
        navigationController?.pushViewController(CarMakesViewController(), animated: true)
    }

}
