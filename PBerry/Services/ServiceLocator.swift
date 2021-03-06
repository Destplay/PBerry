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
    var detailServices: DetailCompanyServices?
    
    func getCompanyServices() -> CompanyServices {
        if let services = self.companyServices {
            
            return services
        }
        self.companyServices = CompanyServices(self.networkManager)
        
        return self.companyServices ?? CompanyServices(self.networkManager)
    }
    
    func getDetailCompanyServices() -> DetailCompanyServices {
        if let services = self.detailServices {
            
            return services
        }
        self.detailServices = DetailCompanyServices(self.networkManager)
        
        return self.detailServices ?? DetailCompanyServices(self.networkManager)
    }
}
