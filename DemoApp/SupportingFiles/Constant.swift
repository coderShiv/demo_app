//
//  Constant.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 24/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import UIKit
import Foundation

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
let helperMethod = HelperMethod()

//Error messages
let internetError = "Network connection is not available, Please try again later."

//Scree Height and width
let deviceHeight = UIScreen.main.bounds.size.height
let deviceWidth = UIScreen.main.bounds.size.width

class Constant: NSObject {
    struct userBaseUrl {
        static let Url = "https://next.json-generator.com/api/json/get/Vk-LhK44U"
    }
}
