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
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            videoView.heightAnchor.constraint(equalToConstant: self.bounds.width),
            
            nameLabel.topAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            distanceLabel.topAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: 4),
            distanceLabel.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 4),
            distanceLabel.heightAnchor.constraint(equalToConstant: 20),
            distanceLabel.widthAnchor.constraint(equalToConstant: 100),
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
