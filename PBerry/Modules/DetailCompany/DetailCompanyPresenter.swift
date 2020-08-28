//
//  DetailCompanyPresenter.swift
//  PBerry
//
//  Created by Роман on 27.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class DetailCompanyPresenter {
    
    weak var delegate: DetailCompanyViewDelegate?
    
    private var sort = SortType.rating
    private var productList = [ProductListResponse.Content]()
    private var commentList = [CommentListResponse.Content]()
    
    init(view: DetailCompanyViewDelegate) {
        self.delegate = view
    }
    
    private func mapping(productList list: [ProductListResponse.Content]) -> [ProductViewModel] {
        let list = list.compactMap { ProductViewModel(product: $0) }
        
        return list
    }
    
    private func mapping(commentList list: [CommentListResponse.Content]) -> [CommentViewModel] {
        let list = list.compactMap { CommentViewModel(comment: $0) }
        
        return list
    }
    
}

extension DetailCompanyPresenter: DetailCompanyPresenterDataSource {
    func fetchProductList(_ id: Int?) {
        let companyId = (id ?? 0)
        let model = ProductListRequest(companyId: companyId.description)
        ServiceLocator.shared.getDetailCompanyServices().fetchProductList(model: model, successful: { list in
            self.productList = list
            let list = self.mapping(productList: list)
            self.delegate?.response(productViewList: list)
        }, failure: { error in
            self.delegate?.response(error: error)
        })
    }
    
    func fetchCommentList(_ id: Int?) {
        let companyId = (id ?? 0)
        let model = CommentListRequest(companyId: companyId.description)
        ServiceLocator.shared.getDetailCompanyServices().fetchCommentList(model: model, successful: { list in
            self.commentList = list
            let list = self.mapping(commentList: list)
            self.delegate?.response(commentViewList: list)
        }, failure: { error in
            self.delegate?.response(error: error)
        })
    }
    
    func sendFeedback(_ id: Int?, status: String, feedback: FeedbackModel) {
        let companyId = (id ?? 0)
        let model = SendFeedbackRequest(companyId: companyId.description, status: status, feedback: feedback)
        ServiceLocator.shared.getDetailCompanyServices().sendFeedback(model: model, successful: {
            self.fetchCommentList(companyId)
        }, failure: { error in
            self.delegate?.response(error: error)
        })
    }
    
    func save(toShopingList product: ProductViewModel) {
        let shoppingListModel = ShoppingListModel(name: product.productName, status: false)
        DataBaseManager.shared.saveDataBase(model: shoppingListModel)
    }
}
