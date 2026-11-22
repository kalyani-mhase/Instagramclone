//
//  UserCell.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mobNumerLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var stodyData: [StoryData] = []
    var cellOnTap: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        self.collectionView.register()
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)

        collectionView.register(
            nib,
            forCellWithReuseIdentifier: "CollectionViewCell"
        )
//        self.collectionView.register(UserCellCollectionViewCell.self, forCellWithReuseIdentifier: "UserCellCollectionViewCell")
        self.collectionView.reloadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
extension UserCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
//            cell.ibl.text = "Demo CollectionView"
            cell.img.image = UIImage(named: "person") ?? UIImage(systemName: "circle.fill")
            if stodyData[indexPath.row%stodyData.count].isView  ?? false{
                cell.storyView.layer.borderColor = UIColor.gray.cgColor
            } else {
                cell.storyView.layer.borderColor = UIColor.purple.cgColor
            }
//            cell.img.layer.cornerRadius = CGFloat(cell.img.frame.height)/2
//            cell.img.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stodyData[indexPath.row%stodyData.count].isView = true
        self.collectionView.reloadData()
        self.cellOnTap?(stodyData[indexPath.row%stodyData.count].image ?? "")
        
    }
    
    
    
}
