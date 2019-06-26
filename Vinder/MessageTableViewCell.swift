//
//  MessageTableViewCell.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-20.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    let videoView:UIView = {
        let v = UIView()
        v.backgroundColor = .yellow
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    var videoURL: URL!
    var videoPlayer = VideoPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(videoView)
        self.addSubview(nameLabel)
        self.addSubview(timestampLabel)
        addSubview(profileImageView)
        profileImageView.image = UIImage(named: "Ray")
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.videoView.topAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalToConstant: 66.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 66.0),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            
            timestampLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8),
            timestampLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
            timestampLabel.heightAnchor.constraint(equalToConstant: 18),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
           
            videoView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 8),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//            videoView.heightAnchor.constraint(equalToConstant: self.bounds.width),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startPreview() {
        guard videoURL != nil else {
            print("invalid url cant play video on cell")
            return
        }
        videoPlayer.playVideo(atUrl: videoURL, on: videoView)
        videoPlayer.player?.pause()
    }
    
    func playVideo() {
        videoPlayer.isLoop = false
        videoPlayer.player?.play()
    }
    
    
    
}
