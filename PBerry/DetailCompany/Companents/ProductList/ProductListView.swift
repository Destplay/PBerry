//
//  ProductListView.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol ProductListDataSource {
    /// Метод для получения модели продукта
    func productList(_ index: Int) -> ProductViewModel?
    
    /// Метод для получения количество элементов в списке
    func productList() -> Int
}

protocol ProductListDelegate {
    func productList(appendToFavorite index: Int)
    func productList(appendToCart index: Int)
}

class ProductListView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: ProductListDataSource?
    var delegate: ProductListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
    }

    func updateComponent() {
        self.tableView.reloadData()
        self.tableView?.isHidden = self.dataSource?.productList() == 0
    }
    
    private func configTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
}

extension ProductListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.dataSource?.productList() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell") as! ProductViewCell
        
        return cell
    }
}

extension ProductListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ProductViewCell {
            guard let product = self.dataSource?.productList(indexPath.row) else { return }
            cell.setup(product)
        }
    }
}
