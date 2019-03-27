//
//  MembersViewController.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 25/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

//Enum for sorting type i.e Name and Age
enum sortingTypeEnum {
    case name
    case age
}

//Enum for sorting options i.e Name(Asc, Desc) & Age(Asc, Desc)
enum sortByEnum {
    case name_asc
    case name_desc
    case age_asc
    case age_desc
}

class MembersViewController: UIViewController {
    
    //MARK: Properties and variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortByNameBtn: UIButton!
    @IBOutlet weak var sortByAgeBtn: UIButton!
    
    var memberList = [RealmMemberModel]()
    var searchedMemberList = [RealmMemberModel]()
    var selectedOptionFromCallback: sortByEnum!
    var isSearchOn = false
    let realm = try! Realm()
    var sortingBy: sortingTypeEnum = .name
    
    //MARK: ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //will return member list from data and sort it in ascending order
        memberList = RealmDBActivity.shared.fetchMemberList().sorted(by: { $0.full_name < $1.full_name })
        defaultSortingType()
    }
    
    //MARK: Button pressed methods
    @IBAction func sortByNameBtnPressed(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        if sortingBy != .name {
            sortingBy = .name
            defaultSortingType()
        }
        if sender.isSelected {
            memberList = memberList.sorted(by: { $0.full_name < $1.full_name })
            sender.isSelected = false
        } else {
            memberList = memberList.sorted(by: { $0.full_name > $1.full_name })
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    @IBAction func sortByAgeBtnPressed(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        if sortingBy != .age {
            sortingBy = .age
            defaultSortingType()
        }
        if sender.isSelected {
            memberList = memberList.sorted(by: { $0.age < $1.age })
            sender.isSelected = false
        } else {
            memberList = memberList.sorted(by: { $0.age > $1.age })
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        if isSearchOn {
            RealmDBActivity.shared.updateMemberList(data: searchedMemberList[sender.tag], isFavorite: sender.isSelected)
        } else {
            RealmDBActivity.shared.updateMemberList(data: memberList[sender.tag], isFavorite: sender.isSelected)
        }
        tableView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        sortingBy = .name
        defaultSortingType()
        sortByNameBtn.isSelected = false
        sortByAgeBtn.isSelected = false
        memberList.removeAll()
        memberList = RealmDBActivity.shared.fetchMemberList().sorted(by: { $0.full_name < $1.full_name })
        tableView.reloadData()
    }
    
    //MARK: Delegate method
    func defaultSortingType() {
        switch sortingBy {
        case .name:
            sortByNameBtn.layer.cornerRadius = 2
            sortByNameBtn.layer.borderColor = UIColor.white.cgColor
            sortByNameBtn.layer.borderWidth = 1
            sortByAgeBtn.layer.borderWidth = 0
            break
        default:
            sortByAgeBtn.layer.cornerRadius = 2
            sortByAgeBtn.layer.borderColor = UIColor.white.cgColor
            sortByAgeBtn.layer.borderWidth = 1
            sortByNameBtn.layer.borderWidth = 0
            break
        }
    }
}

//MARK: Extension for tableview delegate and datasource methods
extension MembersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MemberInfoCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "memberInfo") as? MemberInfoCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "memberInfo") as? MemberInfoCell
        }
        cell.favoriteBtn.tag = indexPath.row
        
        var tempObj = RealmMemberModel()
        if isSearchOn {
            tempObj = searchedMemberList[indexPath.row]
        } else {
            tempObj = memberList[indexPath.row]
        }
        
        cell.favoriteBtn.isSelected = tempObj.isFavorite
        cell.ageLbl.text = "\(String(tempObj.age)) Years"
        if let name = tempObj.full_name {
            cell.nameLbl.text = name
        }
        
        if let mobile = tempObj.phone {
            cell.mobileLbl.text = "\(mobile)"
        }
        
        if let email = tempObj.email {
            cell.emailLbl.text = "\(email)"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchOn {
            return searchedMemberList.count
        }
        return memberList.count
    }
}

//MARK: Searchbar and other helper methods
extension MembersViewController: UISearchBarDelegate {
    
    //MARK: Searchbar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= 0 {
            isSearchOn = false
        } else {
            searchedMemberList.removeAll()
            searchedMemberList = memberList.filter({ ($0.full_name.localizedCaseInsensitiveContains(searchText)) })
            isSearchOn = true
        }
        tableView.reloadData()
    }
}

//MARK: TableViewCell Class
class MemberInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
}
