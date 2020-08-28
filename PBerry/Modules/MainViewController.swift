//
//  MainViewController.swift
//  PBerry
//
//  Created by Роман on 17.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? SearchScreenView else { return }
        
        if let text = self.searchTextField.text, text.count >= 3 {
            controller.setFind(value: text)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Ошибка валидации необходимо ввести больше 3 символов", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
}
