//
//  TopNavigationBar.swift
//  Practice_App
//
//  Created by Kalyani Mhase on 20/11/26.
//
import UIKit
class TopNavigationBar: UIView {
    var topHeader = UILabel()
    private let favoriteBtn = UIButton(type: .system)
    private let messageBtn = UIButton(type: .system)
    var onFavirteTap: (() -> Void)?
    var onMesaageTap:  (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
//    required init?(coder: NSCoder) {
//           super.init(coder: coder)
//           setupUI()
//       }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    
    func setupUI() {
//        backgroundColor = .white
        //
        favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteBtn.tintColor = .black
        favoriteBtn.addTarget(self, action: #selector(favoiteAction), for: .touchUpInside)
        
        //
        messageBtn.setImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        messageBtn.tintColor = .black
        messageBtn.addTarget(self, action: #selector(messageTapped), for: .touchUpInside)
        
        
        //
        topHeader.font = .boldSystemFont(ofSize: 18)
                topHeader.textColor = .black
                topHeader.textAlignment = .center
        [topHeader, favoriteBtn, messageBtn].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteBtn.trailingAnchor.constraint(equalTo: messageBtn.leadingAnchor, constant: 16),
            topHeader.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteBtn.heightAnchor.constraint(equalToConstant: 50),
            favoriteBtn.widthAnchor.constraint(equalToConstant: 50),
            messageBtn.heightAnchor.constraint(equalToConstant: 50),
            messageBtn.widthAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    @objc func favoiteAction() {
        
    }
    
    @objc func messageTapped() {
        
    }
    
}
