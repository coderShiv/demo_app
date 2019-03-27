//
//  CompanyModel.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 23/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation

struct CompanyModel: Decodable {
    var _id: String?
    var company: String?
    var website: String?
    var logo: String?
    var about: String?
    var members: [MemberModel]?
    var isFavorite: Bool?
    var isFollow: Bool?
}
