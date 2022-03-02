//
//  ProductDetailViewModel.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation
import Combine

protocol ProductDetailDelegate: AnyObject {
    func requestSuccess()
    func requestError(error: String)
}

protocol ProductDetailProtocol: AnyObject {
    var name: String? {get}
    var sku: String? {get}
    var priceString: String? {get}
    var quantityString: String? {get}
    var unit: String? {get}
    
    var buttonTitle: String {get}
    var isUpdating: Bool {get}
    func updateProduct(sku: String, name: String, price: Double, unit: String, quantity: Int)
}

class ProductDetailViewModel: ProductDetailProtocol {
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceManager: NetworkServiceProtocol
    private weak var delegate: ProductDetailDelegate?
    private var productVM: ProductProtocol?
    
    init(serviceManager: NetworkServiceProtocol = NetworkService.shared,
         delegate: ProductDetailDelegate,
         productVM: ProductProtocol? = nil) {
        self.serviceManager = serviceManager
        self.delegate = delegate
        self.productVM = productVM
    }
    
    var name: String? {
        return productVM?.name
    }
    
    var sku: String? {
        return productVM?.sku
    }
    
    var priceString: String? {
        if let price = productVM?.price {
            return String(format: "%.0f", price)
        }
        return nil
    }
    var quantityString: String? {
        if let price = productVM?.quantity {
            return String(format: "%d", price)
        }
        return nil
    }
    
    var unit: String? {
        return productVM?.unit
    }
    
    var isUpdating: Bool {
        return productVM != nil
    }
    
    var buttonTitle: String {
        return isUpdating ? "Update" : "Add"
    }
    
    func updateProduct(sku: String, name: String, price: Double, unit: String, quantity: Int) {
        let product = Product(sku: sku, name: name, price: price, unit: unit, quantity: quantity)
        
        if isUpdating {
            self.updateProduct(product)
        }else {
            self.addProduct(product)
        }
    }
    
    private func addProduct(_ product: Product) {
        self.serviceManager.addProduct(product)
            .sink {[weak self] (response) in
            if let _ = response.error {
                self?.delegate?.requestError(error: "Add product error")
            }else {
                self?.delegate?.requestSuccess()
            }
        }
        .store(in: &cancellableSet)
    }
    
    private func updateProduct(_ product: Product) {
        self.serviceManager.updateProduct(product)
            .sink {[weak self] (response) in
            if let _ = response.error {
                self?.delegate?.requestError(error: "Update product error")
            }else {
                self?.delegate?.requestSuccess()
            }
        }
        .store(in: &cancellableSet)
    }

}
