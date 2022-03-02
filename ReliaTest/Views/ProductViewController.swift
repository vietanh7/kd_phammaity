//
//  ProductViewController.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

class ProductViewController: BaseViewController, ProductDetailDelegate {
    class func instantiate(product: ProductProtocol?) -> ProductViewController {
        let screen = AppStoryboards.main.instantiate(viewControllerClass: ProductViewController.self)
        screen.viewModel = ProductDetailViewModel(delegate: screen, productVM: product)
        return screen
    }

    @IBOutlet weak var skuTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var priceTextfield: UITextField!
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBOutlet weak var unitTextfield: UITextField!
    
    var viewModel: ProductDetailProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let updateButton = UIBarButtonItem(title: viewModel?.buttonTitle, style: .plain, target: self, action: #selector(updateTapped))
        navigationItem.rightBarButtonItems = [updateButton]
        
        updateUI()
        
    }
    
    @objc func updateTapped() {
        guard let sku = skuTextfield.text else {
            self.showErrorAlert(error: "Please enter sku")
            return
        }
        
        guard let name = nameTextfield.text else {
            self.showErrorAlert(error: "Please enter name")
            return
        }
        
        guard let unit = unitTextfield.text else {
            self.showErrorAlert(error: "Please enter unit")
            return
        }
        
        guard let price = priceTextfield.text, let priceNumber = Double(price), priceNumber >= 0 else {
            self.showErrorAlert(error: "Please enter valid price")
            return
        }
        
        guard let quantity = quantityTextfield.text, let quantityNumber = Int(quantity), quantityNumber >= 0 else {
            self.showErrorAlert(error: "Please enter valid quantiy")
            return
        }
        
        viewModel?.updateProduct(sku: sku, name: name, price: priceNumber, unit: unit, quantity: quantityNumber)
    }
    
    func requestSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestError(error: String) {
        self.showErrorAlert(error: error)
    }
    
    func updateUI() {
        //update data
        skuTextfield.isEnabled = viewModel?.isUpdating == false
        skuTextfield.text = viewModel?.sku
        skuTextfield.textColor = skuTextfield.isEnabled ? UIColor.black : UIColor.gray
        nameTextfield.text = viewModel?.name
        priceTextfield.text = viewModel?.priceString
        quantityTextfield.text = viewModel?.quantityString
        unitTextfield.text = viewModel?.unit
    }
}
