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
    
    var profileImageURL: String? {
        didSet {
            if let url = profileImageURL {
                 profileImageView.loadThumbnailImage(withURL: url)
            }
        }
    }
    
    var username: String? {
        didSet {
            nameLabel.text = username
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
        v.backgroundColor = .black
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
        label.textColor = .white
        label.text = "caller"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: TNImageView = {
        let v = TNImageView()
        v.image = UIImage(named: "Ray")
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
        profileImageViewTopCons?.constant = bounds.height*1.0/5.0
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
            profileImageViewTopCons!,
            
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

