//
//  Services.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class ServiceLocator {
    
    static let shared = ServiceLocator()
    
    let networkManager = NetworkManager()
    
    var companyServices: CompanyServices?
    
    func getProductsServices() -> CompanyServices {
        if let services = self.companyServices {
            
            return services
        }
        self.companyServices = CompanyServices(self.networkManager)
        
        return self.companyServices ?? CompanyServices(self.networkManager)
    }
}
