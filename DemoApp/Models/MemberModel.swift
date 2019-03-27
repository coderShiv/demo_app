//
//  MemberModel.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 23/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation


struct MemberModel: Decodable {
    
    var _id: String?
    var age: Int?
    var name: NameModel?
    var email: String?
    var phone: String?
    var isFavorite: Bool?
}


struct NameModel: Decodable {
    
    var first: String?
    var last: String?
}
