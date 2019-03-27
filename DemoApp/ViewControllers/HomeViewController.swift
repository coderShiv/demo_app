//
//  HomeViewController.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 23/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class HomeViewController: UIViewController {
    
    //MARK: Properties and variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortBtn: UIButton!
    
    var tempCompanyList = [CompanyModel]()
    var companyList = [RealmCompanyModel]()
    var searchedCompanyList = [RealmCompanyModel]()
    var isSearchOn = false
    
    //MARK: ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Code to set tableview height automatic
        tableView.estimatedRowHeight = 140.0
        tableView.rowHeight = UITableView.automaticDimension
        
        companyList = RealmDBActivity.shared.fetchCompanyList()
        if companyList.count <= 0 {
            getCompanyInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData), name: NSNotification.Name("updateTable"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Button pressed methods
    @IBAction func sortBtnPressed(_ sender: UIButton) {
        searchBar.resignFirstResponder()
        if sender.isSelected {
            companyList = companyList.sorted(by: { $0.company! < $1.company! })
            sender.isSelected = false
        } else {
            companyList = companyList.sorted(by: { $0.company! > $1.company! })
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
            RealmDBActivity.shared.updateCompanyList(data: companyList[sender.tag], key: "favorite", isSelected: sender.isSelected)
        } else {
            RealmDBActivity.shared.updateCompanyList(data: companyList[sender.tag], key: "favorite", isSelected: sender.isSelected)
        }
        tableView.reloadData()
    }
    
    @IBAction func followBtnPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let index = tableView.indexPathForRow(at: point)
        searchBar.resignFirstResponder()
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        if isSearchOn {
            RealmDBActivity.shared.updateCompanyList(data: companyList[index!.row], key: "follow", isSelected: sender.isSelected)
        } else {
            RealmDBActivity.shared.updateCompanyList(data: companyList[index!.row], key: "follow", isSelected: sender.isSelected)
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func memberBtnPreesed(_ sender: UIButton) {
        let memberVC = mainStoryBoard.instantiateViewController(withIdentifier: "MembersViewController") as! MembersViewController
        self.navigationController?.pushViewController(memberVC, animated: true)
    }
}

//MARK: Extension for tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CompanyInfoCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "companyInfo") as? CompanyInfoCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "companyInfo") as? CompanyInfoCell
        }
        
        cell.favoriteBtn.tag = indexPath.row
        var tempObj = RealmCompanyModel()
        if isSearchOn {
            tempObj = searchedCompanyList[indexPath.row]
        } else {
            tempObj = companyList[indexPath.row]
        }
        
        cell.favoriteBtn.isSelected = tempObj.isFavorite
        cell.followBtn.setTitle(tempObj.isFollow ? "Following" : "Follow", for: .normal)
        if let  url = tempObj.logo {
            cell.logoImageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "visitor.png"))
        }
        
        if let company = tempObj.company {
            cell.companyLbl.text = "\(company)"
        }
        
        if let about = tempObj.about {
            cell.descLbl.text = "\(about)"
        }
        
        if let website = tempObj.website {
            cell.website.setTitle(website, for: .normal)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchOn {
            return searchedCompanyList.count
        }
        return companyList.count
    }
}

//MARK: Searchbar and other helper methods
extension HomeViewController: UISearchBarDelegate {
   
    //MARK: Searchbar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count <= 0 {
            isSearchOn = false
        } else {
            searchedCompanyList.removeAll()
            searchedCompanyList = companyList.filter({ $0.company!.localizedCaseInsensitiveContains(searchText) })
            isSearchOn = true
        }
        tableView.reloadData()
    }
    
    //MARK: Helper Methods
    func getCompanyInfo() {
        if !HelperMethod.sharedInstance.isConnectivityOn() {
            SVProgressHUD.showInfo(withStatus: internetError)
            return
        }
        
        SVProgressHUD.show()
        guard let url = URL(string: Constant.userBaseUrl.Url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                SVProgressHUD.showInfo(withStatus: error?.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self.tempCompanyList = try JSONDecoder().decode([CompanyModel].self, from: data)
                self.tempCompanyList = self.tempCompanyList.sorted(by: { $0.company! < $1.company! })
                self.collectMemberInfo(companyList: self.tempCompanyList)
            } catch let error {
                SVProgressHUD.showInfo(withStatus: error as? String)
            }
            }.resume()
    }
    
    func collectMemberInfo(companyList: [CompanyModel]) {
        var memberList = [MemberModel]()
        DispatchQueue.main.async {
            RealmDBActivity.shared.insertCompanyListIntoDB(list: companyList)
            for var object in companyList {
                for i in 0 ..< (object.members?.count)! {
                    object.members![i].isFavorite = false
                    memberList.append(object.members![i])
                }
            }
            RealmDBActivity.shared.insertMemberListIntoDB(list: memberList)
        }
    }
    
    @objc func updateTableData() {
        DispatchQueue.main.async {
            self.companyList = RealmDBActivity.shared.fetchCompanyList()
            self.tableView.reloadData()
        }
    }
}

//MARK: TableViewCell Class
class CompanyInfoCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var website: UIButton!
}
