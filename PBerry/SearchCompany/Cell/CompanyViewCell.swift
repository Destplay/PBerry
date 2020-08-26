//
//  CompanyViewCell.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class CompanyViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    func setup(product: CompanyViewModel) {
        self.logo.downloaded(from: product.image)
        self.name.text = product.companyName
        self.price.text = product.price
        self.distance.text = product.distance
        self.rating.text = product.rating
    }
}
