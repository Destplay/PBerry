//
//  CompanyViewCell.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class CompanyViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func setup(company: CompanyViewModel) {
        self.logoImageView.downloaded(from: company.image)
        self.nameLabel.text = company.companyName
        self.priceLabel.text = company.price
        self.distanceLabel.text = company.distance
        self.ratingLabel.text = company.rating
    }
}
