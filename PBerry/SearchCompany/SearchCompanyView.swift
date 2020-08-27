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

    @IBOutlet weak var tableView: UITableView!
        
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var dataSource: SearchCompanyPresenterDataSource?
    private var list = [CompanyViewModel]()
    private var findValue: String?
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        self.find()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailCompanyView {
            guard let index = sender as? Int, self.list.count > index, let company = self.dataSource?.getCompany(index: index) else { return }
            controller.company = company
            controller.location = self.currentLocation
        }
    }
    
    func setFind(value: String) {
        self.findValue = value
    }
    
    private func configView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Название товара"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        self.tableView?.isHidden = self.list.isEmpty
    }
    
    private func find() {
        self.dataSource?.fetchCompanyList(self.findValue ?? "Все", location: self.currentLocation?.coordinate)
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
    func response(list: [CompanyViewModel]) {
        self.list = list
        self.configView()
    }
    
    func response(error: NSError) {
        print(error)
    }
}

extension SearchCompanyView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellIdentifier") as! CompanyViewCell
        
        return cell
    }
    
    
}

extension SearchCompanyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CompanyViewCell {
            cell.setup(company: self.list[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailCompanySegue", sender: indexPath.row)
    }
}

extension SearchCompanyView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.findValue = searchController.searchBar.text
        if let text = searchController.searchBar.text, text.count >= 3 {
            find()
        }
    }
}
