//
//  RealmDBActivity.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 25/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmDBActivity {
    
    static let shared = RealmDBActivity()
    var realm = try! Realm()
    
    //MARK: Database methods for member
    //Method to insert data in db
    func insertMemberListIntoDB(list: [MemberModel]) {
        for i in 0..<list.count {
            let memberObj = RealmMemberModel()
            memberObj._id = list[i]._id!
            memberObj.age = list[i].age!
            memberObj.full_name = "\((list[i].name?.first)!) \((list[i].name?.last)!)"
            memberObj.phone = list[i].phone!
            memberObj.email = list[i].email!
            memberObj.isFavorite = false
            
            if self.checkDataIdExistForMember(id: memberObj._id) {
                try! realm.write {
                    realm.add(memberObj, update: true)
                }
            } else {
                try! realm.write {
                    realm.add(memberObj)
                }
            }
        }
    }
    
    //Method to update member data
    func updateMemberList(data: RealmMemberModel, isFavorite: Bool) {
        realm = try! Realm()
        if self.checkDataIdExistForMember(id: data._id) {
            try! realm.write {
                data.isFavorite = isFavorite
                realm.add(data, update: true)
            }
        } else {
            try! realm.write {
                data.isFavorite = isFavorite
                realm.add(data)
            }
        }
    }
    
    //Method to fetch member data from db
    func fetchMemberList() -> [RealmMemberModel] {
        realm = try! Realm()
        let memberList = realm.objects(RealmMemberModel.self).toArray(ofType: RealmMemberModel.self)
        return memberList
    }
    
    //Method will return true or false respective to id exist in db or not
    func checkDataIdExistForMember(id: String) -> Bool {
        return realm.object(ofType: RealmMemberModel.self, forPrimaryKey: id) != nil
    }
    
    //MARK: Database methods for company
    //Method to insert company data
    func insertCompanyListIntoDB(list: [CompanyModel]) {
        for i in 0..<list.count {
            let companyObj = RealmCompanyModel()
            companyObj._id = list[i]._id!
            companyObj.company = list[i].company!
            companyObj.website = list[i].website!
            companyObj.logo = list[i].logo!
            companyObj.about = list[i].about!
            companyObj.isFavorite = false
            companyObj.isFollow = false
            realm = try! Realm()
            try! realm.write {
                realm.add(companyObj)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("updateTable"), object: nil)
    }
    
    //Method to update company data
    func updateCompanyList(data: RealmCompanyModel, key: String, isSelected: Bool) {
        realm = try! Realm()
        try! realm.write {
            if key == "follow" {
                data.isFollow = isSelected
            } else {
                data.isFavorite = isSelected
            }
            realm.add(data, update: true)
        }
    }
    
    //Method to fetch company data from db
    func fetchCompanyList() -> [RealmCompanyModel] {
        realm = try! Realm()
        let companyList = realm.objects(RealmCompanyModel.self).toArray(ofType: RealmCompanyModel.self)
        return companyList
    }
    
    //Method will return true or false respective to id exist in db or not
    func checkDataIdExistForCompany(id: String) -> Bool {
        return realm.object(ofType: RealmMemberModel.self, forPrimaryKey: id) != nil
    }
}

//MARK: Extension to convert realm result in desired type
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}
