//
//  CustomCollectionViewCell.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-20.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class ContactsCollectionViewCell: UICollectionViewCell {
  
  let profileImageView:ProfileImageView = {
    let iv = ProfileImageView()
    iv.backgroundColor = .clear
    iv.layer.masksToBounds = false 
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
    
  }()
  
  let nameLabel:UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.backgroundColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
    
    var friend: User? {
        didSet{
            setProfileImage()
            if let frd = friend {
                nameLabel.text = frd.name
            }
        }
    }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(profileImageView)
    self.addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
      profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      profileImageView.heightAnchor.constraint(equalToConstant: self.bounds.width - 20),
      
      nameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 0),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
      nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      nameLabel.heightAnchor.constraint(equalToConstant: 20)
      ])
    
    profileImageView.layer.cornerRadius = (self.bounds.width - 20) / 2
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    func setProfileImage() {
        if let friendID = friend?.uid {
            profileImageView.loadProfileImage(withID: friendID) { (_) in }
        }
    }

}
