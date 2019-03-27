//
//  RealmMemberModel.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 25/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmMemberModel: Object {
    
    @objc dynamic var _id: String! = ""
    @objc dynamic var full_name: String! = ""
    @objc dynamic var email: String! = ""
    @objc dynamic var phone: String! = ""
    @objc dynamic var isFavorite = false
    @objc dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

