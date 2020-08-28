//
//  DataBaseManager.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import Realm

class DataBaseManager {
    
    static let shared = DataBaseManager()
    var realm: Realm?
    
    init() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        do {
            self.realm = try Realm(configuration: configuration)
        } catch {
            print(error)
        }
    }
    
    func saveDataBase<T: Codable>(content: T) where T: Object {
        do {
            try self.realm?.write {
                self.realm?.deleteAll()
                self.realm?.add(content)
            }
        } catch {
            print(error)
        }
    }
    
    func loadDataBase<T: Codable>(predicate: String, type: T.Type) -> T? where T: Object  {
        let object = self.realm?.objects(T.self).filter(predicate).first
        
        return object
    }
    
}
