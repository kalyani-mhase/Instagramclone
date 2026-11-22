//
//  HomeViewController.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topBar: TopNavigationBar!
    let users: [User] = [User(name: "Kalyani", address: "Wagholi, Pune, MH", mob_number: "9518352333", storyData: [StoryData(image: "person",isView: false),StoryData(image: "perosn",isView: false)]),User(name: "Tushar", address: "Airoli, Navi mumbai, MH", mob_number: "9168168012",storyData:[StoryData(image: "person",isView: false),StoryData(image: "perosn",isView: false)])]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        self.tblView.register(UINib(nibName: "UserPostCell", bundle: nil), forCellReuseIdentifier: "UserPostCell")
        topBar.topHeader.text = "Instagram"
        tblView.contentInset = .zero

        tblView.scrollIndicatorInsets = .zero

        tblView.contentInsetAdjustmentBehavior = .never

        tblView.sectionHeaderTopPadding = 0
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as?  UserCell {
                cell.nameLbl.text = users[indexPath.row%users.count].name ?? ""
                cell.addressLbl.text = users[indexPath.row%users.count].address ?? ""
                cell.mobNumerLbl.text = users[indexPath.row%users.count].mob_number ?? ""
                cell.stodyData = users[indexPath.row%users.count].storyData
                cell.cellOnTap = { [weak self] imageName  in
                    self?.preView(img: imageName)
                }
                return cell
            }
        } else{
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as?  UserPostCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func preView(img: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

       if let popupVC = storyboard.instantiateViewController(
            withIdentifier: "PreviewViewController"
       ) as? PreviewViewController {
           
           popupVC.str = "person"
           
           popupVC.modalPresentationStyle = .overFullScreen
           popupVC.modalTransitionStyle = .crossDissolve
        
           
           
           present(popupVC, animated: true)
           //        let vc = PreviewViewController()
           //        vc.str = img
           //        self.present(vc, animated: true)
       }
    }
}
