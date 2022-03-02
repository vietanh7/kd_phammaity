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
    var addButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        
        //configure tableview
        tableView.registerCellFromNib(ProductTableViewCell.self)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        //configure searchbar
        searchBar.placeholder = "Search by sku"
        
        //Add button
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addProduct))
        navigationItem.rightBarButtonItems = [addButton!]
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
    
    @objc func addProduct() {
        showAddScreen()
    }
    
    func updateUI() {
        addButton?.isEnabled = viewModel?.isAuthenticated ?? false
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
            cell.updateUI(productVM: productVM, authenticated: viewModel?.isAuthenticated ?? false)
            cell.onTapEdit = {[weak self] in
                self?.showEditScreen(product: productVM)
            }
            
            cell.onTapDelete = {[weak self] in
                self?.confirmDeleteAlert(sku: productVM.sku)
            }
        }
        
        return cell
    }
    
    func showEditScreen(product: ProductProtocol) {
        let vc = ProductViewController.instantiate(product: product)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAddScreen() {
        let vc = ProductViewController.instantiate(product: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func confirmDeleteAlert(sku: String){
        let alert = UIAlertController(title: "Delete product", message: "Do you want to delete product \(sku)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Detele", style: .destructive, handler: {[weak self] action in
            self?.viewModel?.deleteProduct(sku: sku)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: HomeDelegate
extension HomeViewController: HomeDelegate {
    func productsDidLoad() {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func requestError(error: String) {
        self.tableView.refreshControl?.endRefreshing()
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

