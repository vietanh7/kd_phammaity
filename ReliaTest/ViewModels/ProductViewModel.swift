//
//  ProductViewModel.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import Foundation

protocol ProductProtocol {
    var name: String {get}
    var sku: String {get}
    var authenticated: Bool {get set}
    var onEditTapped:((Product) -> Void)? {get set}
    var onDeleteTapped:((String) -> Void)? {get set}
}

class ProductViewModel: ProductProtocol {
    private let product: Product
    var authenticated: Bool = false
    
    var onEditTapped: ((Product) -> Void)?
    
    var onDeleteTapped: ((String) -> Void)?
    
    init(product: Product) {
        self.product = product
    }
    
    var name: String {
        return product.productName
    }
    
    var sku: String {
        return product.sku
    }
}
