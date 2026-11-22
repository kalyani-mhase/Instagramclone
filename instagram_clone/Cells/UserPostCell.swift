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
    var onFavoriteAction: (()->Void)?
    var onBookMarkAction: (()->Void)?
    var post: PostData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
    }
    
    func setupUI(){
        self.shareOutlet.imageView?.image = UIImage(named: AppImages.send)
        self.bookMarkOutlet.imageView?.image = post?.isBookMark == true ? UIImage(named: AppImages.bookmark_fill) : UIImage(named: AppImages.bookMark)
        self.favoriteOutlet.imageView?.image = post?.isLike == true ? UIImage(named: AppImages.heart) : UIImage(named: AppImages.favourite)
        self.bookMarkOutlet.imageView?.image = post?.isBookMark == true ? UIImage(named: AppImages.bookmark_fill) : UIImage(named: AppImages.bookMark)
//        self.shareOutlet.setImage(UIImage(named: AppImages.send), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreAction(_ sender: Any) {
    
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
//        self.favoriteOutlet.imageView?.image = UIImage(
        self.onFavoriteAction?()
    }
    
    
    @IBAction func postComments(_ sender: Any) {
    }
    
    @IBAction func sharePost(_ sender: Any) {
    }
    
    
    @IBAction func bookMarkPost(_ sender: Any) {
        self.onBookMarkAction?()
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


