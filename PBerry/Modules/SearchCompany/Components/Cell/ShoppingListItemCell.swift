//
//  ShopingListItemCell.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class ShoppingListItemCell: UITableViewCell {

    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!

    var action: (() -> ())?
    
    func setup(product: ShoppingListItemViewModel) {
        self.nameProductLabel.text = product.name
        self.statusSwitch.isOn = product.status
    }

    @IBAction func actionSwitch(_ sender: Any) {
        if let action = action {
            action()
        }
    }
    
}
