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
    func productList(appendToShoppingList index: Int)
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
    
    private func alert(index: Int) {
        let actions = [
            UIAlertAction(title: "В список покупок", style: .default, handler: { _ in
                self.delegate?.productList(appendToShoppingList: index)
            }),
            UIAlertAction(title: "В корзину", style: .default, handler: { _ in
                self.delegate?.productList(appendToCart: index)
            }),
            UIAlertAction(title: "Отмена", style: .cancel)
        ]
        
        let alert = UIAlertController(title: "Меню", message: "Добавить данный продукт?", preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}

extension ProductListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.dataSource?.productList() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCellIdentifier", for: indexPath) as! ProductViewCell
        
        return cell
    }
}

extension ProductListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ProductViewCell {
            guard let product = self.dataSource?.productList(indexPath.row) else { return }
            cell.setup(product)
            
            cell.action = {
                self.alert(index: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
