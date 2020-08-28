//
//  ProductViewCellTableViewCell.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class ProductViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var action: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(_ product: ProductViewModel) {
        self.logoImageView.downloaded(from: product.image)
        self.titleLabel.text = product.productName
        self.subtitleLabel.text = product.attribute
        self.priceLabel.text = product.price
        self.departmentLabel.text = product.department
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        if let action = action {
            action()
        }
    }
    
}
