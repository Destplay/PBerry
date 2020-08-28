//
//  NavigatorCompanyList.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit

protocol NavigatorCompanyDataSource {
    func navigatorCompany(_ imageCompany: UIImageView) -> UIImageView
}

protocol NavigatorCompanyDelegate {
    func navigatorCompany(_ currentTab: NavigatorTabType)
}

enum NavigatorTabType: Int {
    case productList, map, info, feedback
}

class NavigatorCompanyView: UIViewController {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var imageView: UIImageView!
    
    var dataSource: NavigatorCompanyDataSource?
    var delegate: NavigatorCompanyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageView = self.dataSource?.navigatorCompany(self.imageView)
    }
    
}

extension NavigatorCompanyView: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.delegate?.navigatorCompany(NavigatorTabType(rawValue: item.tag) ?? .productList)
    }
}
