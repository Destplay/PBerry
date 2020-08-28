//
//  InfoCompanyView.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol InfoCompanyDataSource {
    func infoCompany() -> InfoCompanyViewModel
}

struct InfoCompanyViewModel {
    var name = "Компания без названия"
    var description = "Описание не заполнено"
    var number = "Номер скрыт"
    var email = "email адрес скрыт"
    var site = "Сайт не указан"
    var address = "Адрес скрыт"
}

class InfoCompanyView: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var dataSource: InfoCompanyDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView()
    }
    
    private func configView() {
        let info = self.dataSource?.infoCompany()
        self.nameLabel.text = info?.name
        self.descriptionLabel.text = info?.description
        self.numberLabel.text = info?.number
        self.emailLabel.text = info?.email
        self.siteLabel.text = info?.site
        self.addressLabel.text = info?.address
    }

}
