//
//  RealmCompanyModel.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 25/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmCompanyModel: Object {
    
    @objc dynamic var _id: String! = ""
    @objc dynamic var company: String! = ""
    @objc dynamic var website: String! = ""
    @objc dynamic var logo: String! = ""
    @objc dynamic var about: String! = ""
    @objc dynamic var isFavorite = false
    @objc dynamic var isFollow = false
    let members = List<RealmMemberModel>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
