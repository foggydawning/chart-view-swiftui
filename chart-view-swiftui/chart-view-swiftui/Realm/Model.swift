//
//  Model.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 31.01.2022.
//

import RealmSwift
import Foundation

final class RealmGroupValuesModel: Object, ObjectKeyIdentifiable {
    
    @objc dynamic var _id = ObjectId.generate()
    let values = List<RealmValueModel>()
    
    override class func primaryKey() -> String? {
        return "_id"
      }
}

final class RealmValueModel: Object {
    @objc dynamic var date = Date()
    @objc dynamic var value: Int = 0
}
