//
//  ProductTableViewCell.swift
//  ReliaTest
//
//  Created by Ty Pham on 02/03/2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonContainerView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var onTapEdit:(()->Void)?
    var onTapDelete:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(productVM: ProductProtocol, authenticated: Bool) {
        self.skuLabel.text = productVM.sku
        self.nameLabel.text = productVM.name
        self.buttonContainerView.isHidden = !authenticated
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.onTapDelete?()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.onTapEdit?()
    }
    
}
