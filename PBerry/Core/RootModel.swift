//
//  RootModel.swift
//  PBerry
//
//  Created by Роман on 27.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

protocol RootResponse: Decodable {
    var status: String { get }
    var errorText: String? { get }
}

class ErrorHandler {
    
    static let shared = ErrorHandler()
    
    func checkStatus<T: RootResponse>(model: T, successful: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        if model.status == "success" {
            successful()
        } else {
            failure(NSError(domain: model.errorText ?? "Неизвестная ошибка", code: 0))
        }
    }
}
