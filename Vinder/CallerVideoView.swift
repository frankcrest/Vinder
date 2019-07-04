//
//  CallerVideoView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-01.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class CallerVideoView: UIView {

    let ws = WebService()
    
    var userID: String? {
        didSet {
            if let id = userID {
                profileImageView.loadProfileImage(withID: id) { (userInfo) in
                    DispatchQueue.main.async {
                        self.userName = userInfo["name"] as? String
                    }
                }
            }
        }
    }
    
    var userName: String? {
        didSet {
            nameLabel.text = userName
        }
    }
    
    
    let buttonContainer:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let callerProfileView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.alpha = 0.5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let declineButton:RoundedButton = {
        let b = RoundedButton()
        b.setImage(UIImage(named: "decline"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    let answerButton:RoundedButton = {
        let b = RoundedButton()
        b.setImage(UIImage(named: "answer"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: ProfileImageView = {
        let v = ProfileImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    var profileImageViewTopCons: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    
    //UI setup
    func setUpViews(){
        
        addSubview(callerProfileView)
        insertSubview(buttonContainer, aboveSubview: callerProfileView)
        insertSubview(nameLabel, aboveSubview: callerProfileView)
        insertSubview(profileImageView, aboveSubview: callerProfileView)
        profileImageView.layer.cornerRadius = 10
        buttonContainer.addArrangedSubview(declineButton)
        buttonContainer.addArrangedSubview(answerButton)
        
        profileImageViewTopCons = profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
//            profileImageViewTopCons!,
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 22),
            
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3.0/4.0),
            buttonContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            buttonContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            
            declineButton.widthAnchor.constraint(equalTo: buttonContainer.heightAnchor),
            declineButton.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor),
            answerButton.widthAnchor.constraint(equalTo: buttonContainer.heightAnchor),
            answerButton.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor),
            
            callerProfileView.widthAnchor.constraint(equalTo: widthAnchor),
            callerProfileView.heightAnchor.constraint(equalTo: heightAnchor),
            callerProfileView.centerYAnchor.constraint(equalTo: centerYAnchor),
            callerProfileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            ])
        
    }
    

}

