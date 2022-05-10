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
    
    /*
     Marks the method unavailable, so that we cannot instantiate this vc from interface builder
     */
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    /*
     Performing no action here since we are not using interface builder
     */
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
        navigationController?.pushViewController(CarMakesViewController(viewmodel: viewmodel.favouritesViewModel), animated: true)
    }
}

