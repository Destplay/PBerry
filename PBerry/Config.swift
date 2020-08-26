//
//  Config.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class Config {
    static let url = "http://lc.pberry.ru/"
}

enum MethodRequest: String {
    case apiCompany = "baza_company.php"
    case apiProducts = "baza_products.php"
    case apiMessages = "baza_messages.php"
}
