//
//  HomeViewModel.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation
import Combine
import Foundation
import SwiftKeychainWrapper

protocol HomeDelegate: AnyObject {
    func productsDidLoad()
    func requestError(error: String)
}

protocol HomeProtocol: AnyObject {
    func numberOfRows() -> Int
    func productVM(at index: Int) -> ProductProtocol
    func fetchProducts()
    func checkAuthentication()
    func deleteProduct(sku: String)
    var isAuthenticated: Bool {get set}
}

class HomeViewModel: HomeProtocol {
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceManager: NetworkServiceProtocol
    private weak var delegate: HomeDelegate?
    
    var productVMs: [ProductProtocol] = []
    var isAuthenticated: Bool = false
    
    init(serviceManager: NetworkServiceProtocol = NetworkService.shared, delegate: HomeDelegate) {
        self.serviceManager = serviceManager
        self.delegate = delegate
    }
    
    func numberOfRows() -> Int {
        return productVMs.count
    }
    
    func productVM(at index: Int) -> ProductProtocol {
        return productVMs[index]
    }
    
    func fetchProducts() {
        serviceManager.fetchProuducts()
            .sink {[weak self] (response) in
                if let _ = response.error {
                    self?.delegate?.requestError(error: "System error")
                }else {
                    self?.handleResponseData(products: response.value ?? [])
                    self?.delegate?.productsDidLoad()
                }
            }
            .store(in: &cancellableSet)
    }
    
    func deleteProduct(sku: String) {
        serviceManager.deleteProduct(sku: sku)
            .sink {[weak self] (response) in
                if let _ = response.error {
                    self?.delegate?.requestError(error: "System error")
                }else {
                    self?.fetchProducts()
                }
            }
            .store(in: &cancellableSet)
    }
    
    func handleResponseData(products:[Product]){
        self.productVMs = products.map{ProductViewModel(product: $0)}
    }
    
    func checkAuthentication() {
        let token = KeychainWrapper.standard.string(forKey: Constants.tokenKey)
        self.isAuthenticated = token != nil
    }
}


