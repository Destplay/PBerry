//
//  DetailCompanyView.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailCompanyView: UIViewController {
    
    @IBOutlet weak var navigationCompanyComponent: UIView!
    @IBOutlet weak var productListComponent: UIView!
    @IBOutlet weak var mapCompanyComponent: UIView!
    @IBOutlet weak var infoCompanyComponent: UIView!
    @IBOutlet weak var feedbackCompanyComponent: UIView!
    
    var company: SearchCompanyResponse.Content?
    var location: CLLocation?
    
    private var productViewList: [ProductViewModel]?
    private var commentViewList: [CommentViewModel]?
    private var dataSource: DetailCompanyPresenterDataSource?
    private var productListView: ProductListView?
    private var feedbackCompanyView: FeedbackCompanyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.dataSource = DetailCompanyPresenter(view: self)
        self.setTab(type: .productList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NavigatorCompanyView {
            controller.dataSource = self
            controller.delegate = self
        }
        
        if let controller = segue.destination as? ProductListView {
            controller.dataSource = self
            controller.delegate = self
            self.productListView = controller
        }
        
        if let controller = segue.destination as? MapCompanyView {
            controller.dataSource = self
        }
        
        if let controller = segue.destination as? InfoCompanyView {
            controller.dataSource = self
        }
        
        if let controller = segue.destination as? FeedbackCompanyView {
            controller.dataSource = self
            controller.delegate = self
            self.feedbackCompanyView = controller
        }
    }
    
    private func setTab(type: NavigatorTabType) {
        self.productListComponent.isHidden = true
        self.mapCompanyComponent.isHidden = true
        self.infoCompanyComponent.isHidden = true
        self.feedbackCompanyComponent.isHidden = true
        
        switch(type) {
            case .productList:
                self.productListComponent.isHidden = false
                self.dataSource?.fetchProductList(self.company?.companyId)
            case .map: self.mapCompanyComponent.isHidden = false
            case .info: self.infoCompanyComponent.isHidden = false
            case .feedback:
                self.feedbackCompanyComponent.isHidden = false
                self.dataSource?.fetchCommentList(self.company?.companyId)
        }
    }
}

extension DetailCompanyView: NavigatorCompanyDataSource {
    func navigatorCompany(_ imageCompany: UIImageView) -> UIImageView {
        imageCompany.downloaded(from: Config.url + (self.company?.image ?? "https://www.natknn.ru/wp-content/uploads/2019/05/no_photo.png"))
        
        return imageCompany
    }
}

extension DetailCompanyView: NavigatorCompanyDelegate {
    func navigatorCompany(_ currentTab: NavigatorTabType) {
        self.setTab(type: currentTab)
    }
}

extension DetailCompanyView: ProductListDataSource {
    func productList(_ index: Int) -> ProductViewModel? {
        guard let list = self.productViewList, list.count > index else { return nil }
        
        return list[index]
    }
    
    func productList() -> Int {
        
        return self.productViewList?.count ?? 0
    }
}

extension DetailCompanyView: ProductListDelegate {
    func productList(appendToFavorite index: Int) {
        
    }
    
    func productList(appendToCart index: Int) {
        
    }
}

extension DetailCompanyView: MapCompanyDataSource {
    func mapCompany(_ mapView: MKMapView) -> CLLocationCoordinate2D? {
        
        return CLLocationCoordinate2D(latitude: self.company?.latloc ?? 0.0, longitude: self.company?.lonloc ?? 0.0)
    }
}

extension DetailCompanyView: InfoCompanyDataSource {
    func infoCompany() -> InfoCompanyViewModel {
        var info = InfoCompanyViewModel()
        if let company = self.company {
            info.name = company.companyName ?? info.name
            info.description = company.description ?? info.description
            info.number = company.number ?? info.name
            info.email = company.email ?? info.email
            info.site = company.site ?? info.site
            info.address = company.address ?? info.address
        }
        
        return info
    }
}

extension DetailCompanyView: FeedbackCompanyDataSource {
    func feedbackCompany(_ index: Int) -> CommentViewModel? {
        guard let list = self.commentViewList, list.count > index else { return nil }
        
        return list[index]
    }
    
    func feedbackCompany() -> Int {
        
        return self.commentViewList?.count ?? 0
    }
}

extension DetailCompanyView: FeedbackCompanyDelegate {
    func feedbackCompany(didPositive feedback: FeedbackModel) {
        self.dataSource?.sendFeedback(self.company?.companyId, status: "1", feedback: feedback)
    }
    
    func feedbackCompany(didNegative feedback: FeedbackModel) {
        self.dataSource?.sendFeedback(self.company?.companyId, status: "0", feedback: feedback)
    }
}

extension DetailCompanyView: DetailCompanyViewDelegate {
    func response(productViewList: [ProductViewModel]) {
        self.productViewList = productViewList
        self.productListView?.updateComponent()
    }
    
    func response(commentViewList: [CommentViewModel]) {
        self.commentViewList = commentViewList
        self.feedbackCompanyView?.updateComponent()
    }
    
    func response(error: NSError) {
        print(error)
    }
}
