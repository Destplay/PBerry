//
//  CompanyListView.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol CompanyListDataSource {
    /// Метод для получения модели компании
    func companyList(_ index: Int) -> CompanyViewModel?
    
    /// Метод для получения количество элементов в списке
    func companyList() -> Int
}

protocol CompanyListDelegate {
    func companyList(didSelect index: Int)
}

class CompanyListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: CompanyListDataSource?
    var delegate: CompanyListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()
    }
    
    func updateView() {
        self.tableView.reloadData()
        self.tableView?.isHidden = self.dataSource?.companyList() == 0
    }
    
    private func configView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
}

extension CompanyListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource?.companyList() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCellIdentifier") as! CompanyViewCell
        
        return cell
    }
}

extension CompanyListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CompanyViewCell {
            guard let company = self.dataSource?.companyList(indexPath.row) else { return }
            
            cell.setup(company: company)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.companyList(didSelect: indexPath.row)
    }
}
