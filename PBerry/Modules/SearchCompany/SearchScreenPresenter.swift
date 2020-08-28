//
//  SearchCompanyPresenter.swift
//  PBerry
//
//  Created by Роман on 08.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import CoreLocation

class SearchScreenPresenter {
    
    weak var delegate: SearchScreenViewDelegate?
    
    private var sort = SortType.rating
    private var companyList = [SearchScreenResponse.Content]()
    private var shoppingList = [ShoppingListModel]()
    private var findValue: String = "Все"
    private var location: CLLocationCoordinate2D?
    
    init(view: SearchScreenViewDelegate) {
        self.delegate = view
    }
    
    private func mapping(companyList: [SearchScreenResponse.Content]) -> [CompanyViewModel] {
        let list = companyList.compactMap { CompanyViewModel(company: $0) }
        
        return list
    }
    
    private func mapping(shoppingList: [ShoppingListModel]) -> [ShoppingListItemViewModel] {
        let list = shoppingList.compactMap { ShoppingListItemViewModel(name: $0.name, status: $0.status) }
        
        return list
    }
    
}

extension SearchScreenPresenter: SearchScreenPresenterDataSource {
    func setSort(sort: SortType) {
        self.sort = sort
        self.fetchCompanyList(self.findValue, location: self.location)
    }
    
    func fetchCompanyList(_ value: String, location: CLLocationCoordinate2D?) {
        self.findValue = value
        self.location = location
        let model = SearchScreenRequest(findValue: value, sort: self.sort.rawValue, latloc: location?.latitude, lonloc: location?.longitude)
        ServiceLocator.shared.getCompanyServices().fetchCompany(model: model, successful: { list in
            self.companyList = list
            let list = self.mapping(companyList: list)
            self.delegate?.response(companyList: list)
        }, failure: { error in
            self.delegate?.response(error: error)
        })
    }
    
    func getCompany(index: Int) -> SearchScreenResponse.Content? {
        guard self.companyList.count > index else { return nil }
        
        return self.companyList[index]
    }
    
    func getShoppingList(_ value: String?) {
        let predicate = value != nil ? "name BEGINSWITH '\(value!)'" : nil
        guard let list = DataBaseManager.shared.loadDataBase(predicate: predicate, type: ShoppingListModel.self) else { return }

        self.shoppingList = list.compactMap( { ShoppingListModel(productId: $0.productId, name: $0.name, status: $0.status) } )
        self.delegate?.response(shoppingList: self.mapping(shoppingList: self.shoppingList))
    }
    
    func setShoppingList(index: Int) {
        guard self.shoppingList.count > index else { return }
        let item = self.shoppingList[index]
        DataBaseManager.shared.saveDataBase(model: item, predicate: item.productId)
    }
    
    func removeAllShoppingList() {
        DataBaseManager.shared.removeAll(type: ShoppingListModel.self)
    }
}
