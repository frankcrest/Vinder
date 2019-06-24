//
//  VideoView.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/19/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var isLoop: Bool = false
    
    let buttonContainer:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let videoContainer:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let sendMessageButton:UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 0.5 * 50
        b.clipsToBounds = true
        b.backgroundColor = UIColor.yellow
        b.imageView?.contentMode = .scaleAspectFit
        b.setImage(UIImage(named: "message"), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        b.addTarget(self, action: #selector(sendMessageTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let callButton:UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 0.5 * 50
        b.clipsToBounds = true
        b.backgroundColor = UIColor.red
        b.setImage(UIImage(named: "call"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        b.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    //UI setup
    func setUpViews(){
        self.addSubview(buttonContainer)
        self.addSubview(videoContainer)
        self.buttonContainer.addSubview(callButton)
        self.buttonContainer.addSubview(sendMessageButton)
        
        NSLayoutConstraint.activate([
            buttonContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            buttonContainer.heightAnchor.constraint(equalToConstant: 80),
            buttonContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            buttonContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            videoContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            videoContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            videoContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            videoContainer.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -5),
            
            callButton.heightAnchor.constraint(equalToConstant: 50),
            callButton.widthAnchor.constraint(equalToConstant: 50),
            callButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -50),
            callButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 15),
            
            sendMessageButton.heightAnchor.constraint(equalToConstant: 50),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 50),
            sendMessageButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 50),
            sendMessageButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 15),
            ])
        
    }

    //AVPlayer methods
    func configure(url: String) {
        let videoURL = URL(string: url)
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoContainer.frame
        self.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func play() {
        if player.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player.play()
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.pause()
        player.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player.pause()
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    //handle call
    @objc func callTapped(){
        print("call")
    }
    
    @objc func sendMessageTapped(){
        print("send video message")
    }
}
