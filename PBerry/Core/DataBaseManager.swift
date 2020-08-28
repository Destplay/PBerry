//
//  DataBaseManager.swift
//  PBerry
//
//  Created by Роман on 28.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    func saveDataBase(model: ShoppingListModel, predicate: String? = nil) {
        do {
            try self.realm?.write {
                if let predicate = predicate {
                    if let object = self.realm?.objects(ShoppingListModel.self).filter("productId = %@", predicate).first {
                        object.status.toggle()
                    }
                } else {
                    self.realm?.add(model)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func loadDataBase<T>(predicate: String?, type: T.Type) -> Results<T>? where T: Object  {
        if let predicate = predicate {
            return self.realm?.objects(T.self).filter(predicate)
        } else {
            return self.realm?.objects(T.self)
        }
    }
    
    func removeAll<T>(type: T.Type) where T: Object  {
        do {
            try self.realm?.write {
                guard let objects = self.realm?.objects(T.self) else { return }
                self.realm?.delete(objects)
            }
        } catch {
            print(error)
        }
    }
    
}
