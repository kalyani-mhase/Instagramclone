//
//  UserPostCell.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

import UIKit

class UserPostCell: UITableViewCell {
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    
    @IBOutlet weak var favoriteOutlet: UIButton!
    
    
    @IBOutlet weak var commentOutlet: UIButton!
    
    @IBOutlet weak var shareOutlet: UIButton!
    
    @IBOutlet weak var bookMarkOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func moreAction(_ sender: Any) {
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
    }
    
    @IBAction func postComments(_ sender: Any) {
    }
    @IBAction func sharePost(_ sender: Any) {
    }
    
    @IBAction func bookMarkPost(_ sender: Any) {
    }
}
extension UserPostCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let postCell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell {
            return postCell
        }
        return UICollectionViewCell()
    }
}
    extension ViewController: UICollectionViewDelegateFlowLayout {

//        func collectionView(
//            _ collectionView: UICollectionView,
//            layout collectionViewLayout: UICollectionViewLayout,
//            sizeForItemAt indexPath: IndexPath
//        ) -> CGSize {
//
//            return CGSize(
//                width: collectionView.bounds.width,
//                height: collectionView.bounds.height
//            )
//        }
    }

