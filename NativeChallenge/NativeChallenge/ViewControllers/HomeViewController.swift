//
//  HomeViewController.swift
//  NativeChallenge
//
//  Created by KunalGandhi on 09.05.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    let label = UILabel()
    let viewmodel: HomeViewModel
    
    init(viewmodel: HomeViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Loading this viewcontroller from nib is currently unsupported")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable, message: "Loading this viewcontroller from nib is currently unsupported")
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(viewCarMakes))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = "Favourite Count: \(viewmodel.favouritesCount)"
        navigationItem.titleView = label
    }
    
    @objc func viewCarMakes() {
        navigationController?.pushViewController(CarMakesViewController(viewmodel: viewmodel.carMakesViewModel), animated: true)
    }
}

