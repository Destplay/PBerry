//
//  ShopingListItemCell.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class ShopingListItemCell: UITableViewCell {

    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!

    func setup(product: ShopingListItemViewModel) {
        self.nameProductLabel.text = product.name
        self.statusSwitch.isOn = product.status
    }

}
