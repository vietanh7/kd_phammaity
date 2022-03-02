//
//  HomeViewController.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var authenticatedLabel: UILabel!
    
    @IBOutlet weak var buttonContainerView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: HomeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        
        //configure tableview
        tableView.registerCellFromNib(ProductTableViewCell.self)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        //configure searchbar
        searchBar.placeholder = "Search by sku"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.checkAuthentication()
        updateUI()
        
        viewModel?.fetchProducts()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
    }
    
    @objc func pullToRefresh() {
        //refresh
        viewModel?.fetchProducts()
    }
    
    func updateUI() {
        buttonContainerView.isHidden = viewModel?.isAuthenticated ?? false
        authenticatedLabel.isHidden = !(viewModel?.isAuthenticated ?? false)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ProductTableViewCell.self, forIndexPath: indexPath)
        
        if let productVM = self.viewModel?.productVM(at: indexPath.row) {
            cell.updateUI(productVM: productVM)
        }
        
        return cell
    }
}

//MARK: HomeDelegate
extension HomeViewController: HomeDelegate {
    func productsDidLoad() {
        self.tableView.reloadData()
    }
    
    func requestError(error: String) {
        self.showErrorAlert(error: error)
    }
}

//MARK: SearchDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: search action
        searchBar.resignFirstResponder()
    }
}

