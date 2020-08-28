//
//  DateBaseModels.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingListModel: Object {
    @objc dynamic var productId = UUID().uuidString
    @objc dynamic var name = String()
    @objc dynamic var status = Bool()
    
    override class func primaryKey() -> String? {
        return "productId"
    }
    
    convenience init(productId: String? = nil, name: String, status: Bool) {
        self.init()
        self.productId = productId != nil ? productId! : UUID().uuidString
        self.name = name
        self.status = status
    }
}
