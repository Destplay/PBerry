//
//  SearchCompanyModel.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import CoreLocation

protocol SearchCompanyPresenterDataSource: class {
    func setSort(sort: SortType)
    func fetchCompanyList(_ value: String, location: CLLocationCoordinate2D?)
}

protocol SearchCompanyViewDelegate: class {
    func response(list: [CompanyViewModel])
    func response(error: NSError)
}

enum SortType: String {
    case rating = "RATING"
    case price = "PRICE"
    case distance = "DISTANCE"
}

struct SearchCompanyRequest: Encodable {
    var findValue: String
    var sort: String?
    var latloc: Double
    var lonloc: Double
    
    init(findValue: String?, sort: String, latloc: Double?, lonloc: Double?) {
        self.findValue = findValue ?? "Все"
        self.sort = sort
        self.latloc = latloc ?? 51.509
        self.lonloc = lonloc ?? 0.12
    }
    
    enum CodingKeys: String, CodingKey {
        case findValue = "find", sort, latloc, lonloc
    }
}

struct SearchCompanyResponse: Decodable {
    let status: String
    let content: [Content]?
    let errorText: String?
    
    struct Content: Decodable {
        let companyId: Int?
        let image: String?
        let companyName: String?
        let description: String?
        let distance: Double?
        let price: String?
        let latloc: Double?
        let lonloc: Double?
        let number: String?
        let email: String?
        let address: String?
        let rating: String?
        let categoryId: Int?
        let site: String?
        
        enum CodingKeys: String, CodingKey {
            case companyId = "ids", image, companyName = "company", description, distance, price, latloc, lonloc, number, email, address, rating, categoryId = "category_id", site
        }
    }
}

struct MessagesRequest: Encodable {
    var companyId: String
    
    enum CodingKeys: String, CodingKey {
        case companyId = "idscompany"
    }
}

struct CompanyViewModel {
    let companyName: String
    let distance: String
    let price: String
    let image: String
    let rating: String
    
    init(company: SearchCompanyResponse.Content) {
        self.companyName = company.companyName ?? ""
        self.distance = "🧭 \(String(format: "%.3f", company.distance ?? 0.0)) км"
        self.price = "\(company.price?.description ?? "") ₽"
        self.image = Config.url + (company.image?.description ?? "")
        self.rating = "⭐️ \(company.rating?.description ?? "")"
    }
}
