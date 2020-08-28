//
//  DetailCompanyServices.swift
//  PBerry
//
//  Created by Роман on 27.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class DetailCompanyServices {
    let networkManager: NetworkManager
    
    init(_ networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchProductList(model: ProductListRequest, successful: @escaping ([ProductListResponse.Content]) -> (), failure: @escaping (NSError) -> ()) {
        let url = Config.url + "/api/"
        self.networkManager.requestService(url: url, method: .apiProducts, model: model, successful: { (response: ProductListResponse) in
            ErrorHandler.shared.checkStatus(model: response, successful: {
                guard let list = response.content else { return }
                successful(list)
            }, failure: failure)
        }, failure: failure)
    }
    
    func fetchCommentList(model: CommentListRequest, successful: @escaping ([CommentListResponse.Content]) -> (), failure: @escaping (NSError) -> ()) {
        let url = Config.url + "/api/"
        self.networkManager.requestService(url: url, method: .apiMessages, model: model, successful: { (response: CommentListResponse) in
            ErrorHandler.shared.checkStatus(model: response, successful: {
                guard let list = response.content else { return }
                successful(list)
            }, failure: failure)
        }, failure: failure)
    }
    
    func sendFeedback(model: SendFeedbackRequest, successful: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        let url = Config.url + "/api/"
        self.networkManager.requestService(url: url, method: .apiNewMessage, model: model, successful: { (response: ProductListResponse) in
            ErrorHandler.shared.checkStatus(model: response, successful: successful, failure: failure)
        }, failure: failure)
    }
}
