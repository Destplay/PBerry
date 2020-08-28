//
//  ShoppingListView.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol ShoppingListDataSource {
    /// Метод для получения модели компании
    func shoppingList(_ index: Int) -> ShoppingListItemViewModel?
    
    /// Метод для получения количество элементов в списке
    func shoppingList() -> Int
}

protocol ShoppingListDelegate {
    /// Метод выбора продукта
    func shoppingList(didSelect index: Int)
}

class ShoppingListView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: ShoppingListDataSource?
    var delegate: ShoppingListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView()
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    private func configView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }

}

extension ShoppingListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource?.shoppingList() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellIdentifier") as! ShoppingListItemCell
        
        return cell
    }
}

extension ShoppingListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ShoppingListItemCell {
            guard let product = self.dataSource?.shoppingList(indexPath.row) else { return }
            
            cell.setup(product: product)
            
            cell.action = {
                self.delegate?.shoppingList(didSelect: indexPath.row)
            }
        }
    }
}
