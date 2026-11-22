//
//  CollectionViewCell.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ibl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var storyView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
            super.awakeFromNib()
            storyView.layer.cornerRadius = storyView.bounds.height / 2
        storyView.layer.borderWidth = 3
            img.layer.cornerRadius = img.bounds.height / 2
            img.clipsToBounds = true
        
        
    }
}
