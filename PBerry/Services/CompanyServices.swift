//
//  CompanyServices.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class CompanyServices {
    let networkManager: NetworkManager
    
    init(_ networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchCompany(model: SearchCompanyRequest, successful: @escaping ([SearchCompanyResponse.Content]) -> (), failure: @escaping (NSError) -> ()) {
        let url = Config.url + "/api/"
        self.networkManager.requestService(url: url, method: .apiCompany, model: model, successful: { (response: SearchCompanyResponse) in
            guard let list = response.content else { return }
            successful(list)
        }, failure: failure)
    }
}
