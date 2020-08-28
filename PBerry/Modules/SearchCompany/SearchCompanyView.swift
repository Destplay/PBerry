//
//  ViewController.swift
//  PBerry
//
//  Created by Роман on 06.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit
import CoreLocation

class SearchCompanyView: UIViewController {
        
    @IBOutlet weak var companyListContainer: UIView!
    @IBOutlet weak var shopingListContainer: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    private let locationManager = CLLocationManager()
    private let searchController = UISearchController(searchResultsController: nil)
    private var currentLocation: CLLocation?
    private var dataSource: SearchCompanyPresenterDataSource?
    private var companyViewList = [CompanyViewModel]()
    private var shoppingViewList = [ShopingListItemViewModel]()
    private var findValue: String?
    private var companyListView: CompanyListView?
    private var shoppingListView: ShoppingListView?
    
    override func loadView() {
        super.loadView()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = SearchCompanyPresenter(view: self)
        self.configView()
        self.setTab(type: .companyList)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailCompanyView {
            guard let index = sender as? Int, self.companyViewList.count > index, let company = self.dataSource?.getCompany(index: index) else { return }
            controller.company = company
            controller.location = self.currentLocation
        }
        
        if let controller = segue.destination as? CompanyListView {
            controller.dataSource = self
            controller.delegate = self
            self.companyListView = controller
        }
        
        if let controller = segue.destination as? ShoppingListView {
            controller.dataSource = self
            controller.delegate = self
            self.shoppingListView = controller
        }
    }
    
    func setFind(value: String) {
        self.findValue = value
        self.searchController.searchBar.text = value
    }
    
    private func configView() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Название товара"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        self.tabBar.delegate = self
    }
    
    private func find() {
        self.dataSource?.fetchCompanyList(self.findValue ?? "Все", location: self.currentLocation?.coordinate)
    }
    
    private func setTab(type: SearchScreenType) {
        self.companyListContainer.isHidden = true
        self.shopingListContainer.isHidden = true
        
        switch(type) {
            case .companyList:
                self.companyListContainer.isHidden = false
                self.find()
            case .notification: break
            case .shoppingList: self.shopingListContainer.isHidden = false
            case .cart: break
        }
    }
    
    @IBAction func actionSort(_ sender: Any) {
        let alert = UIAlertController(title: "Сортировка", message: "Сортировать список по:", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Рейтингу", style: .default) { _ in
            self.dataSource?.setSort(sort: .rating)
        })
        alert.addAction(UIAlertAction(title: "Цене", style: .default) { _ in
            self.dataSource?.setSort(sort: .price)
        })
        alert.addAction(UIAlertAction(title: "Растоянию", style: .default) { _ in
            self.dataSource?.setSort(sort: .distance)
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
}

extension SearchCompanyView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }
}

extension SearchCompanyView: SearchCompanyViewDelegate {
    func response(companyList list: [CompanyViewModel]) {
        self.companyViewList = list
        self.companyListView?.updateView()
    }
    
    func response(shoppingList list: [ShopingListItemViewModel]) {
        self.shoppingViewList = list
        self.shoppingListView?.updateView()
    }
    
    func response(error: NSError) {
        print(error)
    }
}

extension SearchCompanyView: CompanyListDataSource {
    func companyList() -> Int {
        
        return self.companyViewList.count
    }
    
    func companyList(_ index: Int) -> CompanyViewModel? {
        guard self.companyViewList.count > index else { return nil }
        
        return self.companyViewList[index]
    }
}

extension SearchCompanyView: CompanyListDelegate {
    func companyList(didSelect index: Int) {
        self.performSegue(withIdentifier: "DetailCompanySegue", sender: index)
    }
}

extension SearchCompanyView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.findValue = searchController.searchBar.text
        if let text = searchController.searchBar.text, text.count >= 3 {
            self.find()
        }
    }
}

extension SearchCompanyView: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.setTab(type: SearchScreenType(rawValue: item.tag) ?? .companyList)
    }
}

extension SearchCompanyView: ShoppingListDataSource {
    func shoppingList() -> Int {
        
        return self.companyViewList.count
    }
    
    func shoppingList(_ index: Int) -> ShopingListItemViewModel? {
        guard self.shoppingViewList.count > index else { return nil }
        
        return self.shoppingViewList[index]
    }
}

extension SearchCompanyView: ShoppingListDelegate {
    func shoppingList(didSelect index: Int) {
        
    }
}
