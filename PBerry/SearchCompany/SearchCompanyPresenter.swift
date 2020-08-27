//
//  SearchCompanyPresenter.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import CoreLocation

class SearchCompanyPresenter {
    
    weak var delegate: SearchCompanyViewDelegate?
    
    private var sort = SortType.rating
    private var list = [SearchCompanyResponse.Content]()
    private var findValue: String = "Все"
    private var location: CLLocationCoordinate2D?
    
    init(view: SearchCompanyViewDelegate) {
        self.delegate = view
    }
    
    private func mapping(list: [SearchCompanyResponse.Content]) -> [CompanyViewModel] {
        let list = list.compactMap { CompanyViewModel(company: $0) }
        
        return list
    }
    
}

extension SearchCompanyPresenter: SearchCompanyPresenterDataSource {
    func setSort(sort: SortType) {
        self.sort = sort
        self.fetchCompanyList(self.findValue, location: self.location)
    }
    
    func fetchCompanyList(_ value: String, location: CLLocationCoordinate2D?) {
        self.findValue = value
        self.location = location
        let model = SearchCompanyRequest(findValue: value, sort: self.sort.rawValue, latloc: location?.latitude, lonloc: location?.longitude)
        ServiceLocator.shared.getCompanyServices().fetchCompany(model: model, successful: { list in
            self.list = list
            let list = self.mapping(list: list)
            self.delegate?.response(list: list)
        }, failure: { error in
            self.delegate?.response(error: error)
        })
    }
    
    func getCompany(index: Int) -> SearchCompanyResponse.Content? {
        guard self.list.count > index else { return nil }
        
        return self.list[index]
    }
}
