//
//  MessageTableViewCell.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-20.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

protocol ShowProfileDelegate: AnyObject {
     func showVideoView(withUser name: String, profileVideoUrl: String)
    func actionToMsg(_ message: Messages)
}

class MessageTableViewCell: UITableViewCell {
    
    var showProfileDelegate: ShowProfileDelegate?
    var isProfileHidden: Bool?
    let containerView:UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var profileImageView: ProfileImageView = {
        let imageview = ProfileImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.isUserInteractionEnabled = true
        imageview.contentMode = .scaleAspectFill
        imageview.layer.borderWidth = 1
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.black.cgColor
        imageview.layer.cornerRadius = 22
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var thumbnailImageView: TNImageView = {
        let imageview = TNImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    var replyButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "reply"), for: .normal)
        b.backgroundColor = .clear
        b.imageView?.bounds.size.height = b.bounds.size.height * 0.6
        b.imageView?.bounds.size.width = b.bounds.size.width * 0.6
        return b
    }()
    

    var thumbnail: UIImage!
    
    var message: Messages? {
        didSet {
            setThumbnailImage()
            setProfileImage()
            if let msg = message {
                nameLabel.text = msg.sender
                timestampLabel.text = "\(serverToLocal(date: msg.timestamp)!)"
            }
        }
    }
    
    var videoPlayer = VideoPlayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func showProfile() {
        
//        guard let username = profileImageView.userName, let url = profileImageView.profileVideoUrl else { return }
        self.showProfileDelegate?.showVideoView(withUser: "username", profileVideoUrl: "url")
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        addSubview(nameLabel)
        addSubview(timestampLabel)
        addSubview(replyButton)
        containerView.addSubview(thumbnailImageView)
        addSubview(profileImageView)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfile)))
        replyButton.addTarget(self, action: #selector(actionToMsg), for: .touchUpInside)
        NSLayoutConstraint.activate([
            
            replyButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            replyButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -4),
            replyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            replyButton.widthAnchor.constraint(equalToConstant: 44.0),
            
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            profileImageView.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -4),
            profileImageView.widthAnchor.constraint(equalToConstant: 44.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 44.0),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            
            timestampLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16),
            timestampLabel.heightAnchor.constraint(equalToConstant: 12),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
           
            containerView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            thumbnailImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setThumbnailImage() {
        
        if let thumbnailImageUrl = message?.imageURL {
            thumbnailImageView.loadThumbnailImage(withURL: thumbnailImageUrl)
        }
    }
    
    func setProfileImage() {
        if let senderID = message?.senderID {
            profileImageView.loadProfileImage(withID: senderID)
        }
    }
    
    @objc func playVideo() {
        
        videoPlayer.isLoop = false
        videoPlayer.player?.play()
    }
    
    @objc func actionToMsg() {
        print("repy tapped")

        self.showProfileDelegate?.actionToMsg(message!)
    }
    
    
    private func serverToLocal(date:Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let str = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.date(from: str)
        return dateFormatter.string(from: localDate!)
    }
    
    
}
