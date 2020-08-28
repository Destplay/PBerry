//
//  CachManager.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation

class CacheManager {

    static let shared = CacheManager()
    
    private var cache = [String: Any]()
    
    let queue = DispatchQueue(label: "ru.destplay.PBerry.CacheManager")
    
    func appendCache<T>(key: String, value: T) {
        self.queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    func getCache<T>(key: String,_ type: T.Type) -> T? {
        self.queue.sync {
            return self.cache[key] as? T
        }
    }
    
}
