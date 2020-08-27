//
//  ServiceManager.swift
//  HLApp
//
//  Created by Роман on 17.03.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func requestService<P: Encodable, R: Decodable>(url: String, method: MethodRequest, model: P, successful: @escaping (R) -> (), failure: @escaping (NSError) -> ()) {
        let urlString = url + method.rawValue
        guard let url = URL(string: urlString) else { return }
        
        guard var parameters: Dictionary = try? model.asDictionary() else { return }
        parameters.updateValue(Config.apiKey, forKey: "secret_key")
        Log.i(parameters, tag: "PARAMETERS - \(method.rawValue)")
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            do {
                guard let data = response.data else { return }
                let model = try JSONDecoder().decode(R.self, from: data)
                Log.i(data.convertToDictionary(), tag: "RESPONSE - \(method.rawValue)")
                successful(model) 
            } catch {
                failure(error as NSError)
            }
        }
    }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
