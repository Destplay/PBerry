//
//  FeedbackCompanyView.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol FeedbackCompanyDataSource {
    /// Метод для получения модели продукта
    func feedbackCompany(_ index: Int) -> CommentViewModel?
    
    /// Метод для получения количество элементов в списке
    func feedbackCompany() -> Int
}

protocol FeedbackCompanyDelegate {
    /// Метод для положительного отзыва
    func feedbackCompany(didPositive feedback: FeedbackModel)
    
    /// Метод для отрицательного отзыва
    func feedbackCompany(didNegative feedback: FeedbackModel)
}

class FeedbackCompanyView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    
    var dataSource: FeedbackCompanyDataSource?
    var delegate: FeedbackCompanyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView()
    }

    func updateComponent() {
        self.tableView.reloadData()
        self.tableView?.isHidden = self.dataSource?.feedbackCompany() == 0
    }
    
    private func configView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.sendFeedbackButton.cornerRadius = self.sendFeedbackButton.frame.height / 2
        self.sendFeedbackButton.layer.borderWidth = 0.1
        self.sendFeedbackButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Имя"
            textField.keyboardType = .default
        })
    
        alert.addTextField(configurationHandler: { textField in
           textField.placeholder = "Сообщение"
           textField.keyboardType = .default
        })
        
        let actions = [
            UIAlertAction(title: "Положительный 👍🏼", style: .default, handler: { action in
                self.delegate?.feedbackCompany(didPositive: FeedbackModel(name: alert.textFields?.first?.text ?? "", message: alert.textFields?.last?.text ?? ""))
            }),
            UIAlertAction(title: "Отрицательный 👎🏼", style: .destructive, handler: { action in
                self.delegate?.feedbackCompany(didNegative: FeedbackModel(name: alert.textFields?.first?.text ?? "", message: alert.textFields?.last?.text ?? ""))
            }),
            UIAlertAction(title: "Отмена", style: .cancel)
        ]
        
        for action in actions {
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func actionSendFeedback(_ sender: Any) {
        self.alert(title: "Отзыв", message: "Оставьте ваш отзыв")
    }
    
}

extension FeedbackCompanyView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.dataSource?.feedbackCompany() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentViewCell") as! CommentViewCell
        
        return cell
    }
}

extension FeedbackCompanyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CommentViewCell {
            guard let comment = self.dataSource?.feedbackCompany(indexPath.row) else { return }
            cell.setup(comment)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
