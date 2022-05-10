import UIKit

class CarMakesViewController: UIViewController {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView()
    let errorLabel = UILabel()
    let viewmodel: CarMakesViewModel
    
    init(viewmodel: CarMakesViewModel) {
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
        setupTableView()
        setupActivityIndicator()
        setupErrorLabel()
        viewmodel.delegate = self
        activityIndicator.startAnimating()
        viewmodel.fetchCarMakes()
    }
    
    override func viewDidLayoutSubviews() {
        setupTableViewConstraints()
        setupActivityIndicatorConstraints()
        setupErrorLabelConstraints()
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarMakeTableViewCell.self, forCellReuseIdentifier: "carmakecell")
        view.addSubview(tableView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
        view.addSubview(errorLabel)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
    
    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([centerX,centerY])
    }
    
    private func setupErrorLabelConstraints() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = NSLayoutConstraint(item: errorLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let height = NSLayoutConstraint(item: errorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100.0)
        let width = NSLayoutConstraint(item: errorLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.80, constant: view.frame.width)
        let centerX = NSLayoutConstraint(item: errorLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
//        NSLayoutConstraint.activate([leading, trailing, centerY, height])
        NSLayoutConstraint.activate([centerX, width, centerY, height])
    }
}


extension CarMakesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.totalCarMakes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carmakecell", for: indexPath) as? CarMakeTableViewCell else {
            fatalError("Could not cast the dequeued table view cell to a CarMakeTableViewCell")
        }
        if let vm = viewmodel.cellModel(at: indexPath.row) {
            cell.makeLabel.text = vm.getName()
            cell.accessoryType = vm.isSelected() ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewmodel.toggleCarMake(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension CarMakesViewController: CarMakesViewModelDelegate {
    func cellViewModelDidChange(_ viewmodel: CarMakesViewModel, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        if let vm = viewmodel.cellModel(at: index) {
            cell?.accessoryType = vm.isSelected() ? .checkmark : .none
        }
    }
    
    func viewModelDidFetchCarMakesWithSuccess(_ viewmodel: CarMakesViewModel) {
        activityIndicator.stopAnimating()
        errorLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func viewModelFetchCarMakesDidFinish(_ viewmodel: CarMakesViewModel, withError error: Error) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
    }
}

extension CarMakesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? HomeViewController {
            vc.viewmodel.favouritesViewModel = viewmodel
        }
    }
}
