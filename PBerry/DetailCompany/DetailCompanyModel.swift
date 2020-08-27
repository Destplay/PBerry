//
//  DetailCompanyModel.swift
//  PBerry
//
//  Created by Роман on 27.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

protocol DetailCompanyPresenterDataSource: class {
    func fetchProductList(_ id: Int?)
    func fetchCommentList(_ id: Int?)
    func sendFeedback(_ id: Int?, status: String, feedback: FeedbackModel)
}

protocol DetailCompanyViewDelegate: class {
    func response(productViewList: [ProductViewModel])
    func response(commentViewList: [CommentViewModel])
    func response(error: NSError)
}

struct ProductListRequest: Encodable {
    var companyId: String
    
    init(companyId: String) {
        self.companyId = companyId
    }
    
    enum CodingKeys: String, CodingKey {
        case companyId = "idscompany"
    }
}

struct ProductListResponse: RootResponse {
    var status: String
    var errorText: String?
    let content: [Content]?
    
    struct Content: Decodable {
        let productId: String?
        let image: String?
        let name: String?
        let department: String?
        let attribute: String?
        let price: String?
        
        enum CodingKeys: String, CodingKey {
            case productId = "ids", image, name, department, attribute, price
        }
    }
}

struct ProductViewModel {
    let productName: String
    let image: String
    let department: String
    let attribute: String
    let price: String
    
    init(product: ProductListResponse.Content) {
        self.productName = product.name ?? ""
        self.image = Config.url + (product.image ?? "")
        self.department = product.department ?? ""
        self.attribute = product.attribute ?? ""
        self.price = "\(product.price ?? "") ₽"
    }
}


struct CommentListRequest: Encodable {
    var companyId: String
    
    init(companyId: String) {
        self.companyId = companyId
    }
    
    enum CodingKeys: String, CodingKey {
        case companyId = "idscompany"
    }
}

struct CommentListResponse: RootResponse {
    var status: String
    var errorText: String?
    let content: [Content]?
    
    struct Content: Decodable {
        let commentId: String?
        let name: String?
        let message: String?
        let date: String?
        let status: String?
        
        enum CodingKeys: String, CodingKey {
            case commentId = "ids", name, message, date, status
        }
    }
}

struct CommentViewModel {
    let name: String
    let message: String
    let date: String
    let status: String
    
    init(comment: CommentListResponse.Content) {
        self.name = comment.name ?? ""
        self.message = comment.message ?? ""
        self.date = comment.date ?? ""
        self.status = comment.status == "1" ? "👍🏼" : "👎🏼"
    }
}

struct SendFeedbackRequest: Encodable {
    var companyId: String
    var name: String
    var message: String
    var status: String
    
    init(companyId: String, status: String, feedback: FeedbackModel) {
        self.companyId = companyId
        self.name = feedback.name
        self.message = feedback.message
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case companyId = "idscompany", name, message, status
    }
}

struct SendFeedbackResponse: RootResponse {
    var status: String
    var errorText: String?
}

struct FeedbackModel {
    let name: String
    let message: String
}
