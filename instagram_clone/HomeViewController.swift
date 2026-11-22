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
    private let viewModel = HomeViewmodel()
    
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
    
    @IBAction func homePressed(_ sender: Any) {
    }
    
    @IBAction func seeProfile(_ sender: Any) {
    }
    
    
    @IBAction func wathcReels(_ sender: Any) {
    }
    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    @IBAction func addContained(_ sender: Any) {
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
            return DataSource.users.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as?  UserCell {
                cell.nameLbl.text = viewModel.users[indexPath.row].name ?? ""
                cell.addressLbl.text = viewModel.users[indexPath.row].address ?? ""
                cell.mobNumerLbl.text = viewModel.users[indexPath.row].mob_number ?? ""
                cell.stodyData = viewModel.users[indexPath.row].storyData
                cell.cellOnTap = { [weak self] imageName  in
                    self?.preView(img: imageName)
                }
                
                return cell
            }
        } else{
            if let cell = tblView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as?  UserPostCell {
                cell.post = DataSource.users[indexPath.row]
                cell.onFavoriteAction = {
                    DataSource.users[indexPath.row].isLike = !(DataSource.users[indexPath.row].isLike)
                    self.reloadRow(indexPath: [indexPath])
                }
                cell.onBookMarkAction = {
                    DataSource.users[indexPath.row].isBookMark = !(DataSource.users[indexPath.row].isBookMark)
                    self.reloadRow(indexPath: [indexPath])
                }
                
                cell.setupUI()
                return cell
            }
        }
        return UITableViewCell()
    }
    func reloadRow(indexPath: [IndexPath]) {
        self.tblView.reloadRows(at: indexPath, with: .none)
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
