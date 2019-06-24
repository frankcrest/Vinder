//
//  IncomeCallView.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/22/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class IncomeCallView: UIView {

    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var isLoop: Bool = false

    
    let pickUpCallButton:UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 0.5 * 50
        b.clipsToBounds = true
        b.backgroundColor = UIColor.yellow
        b.imageView?.contentMode = .scaleAspectFit
        b.setImage(UIImage(named: "call"), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        b.addTarget(self, action: #selector(pickUpCallTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let rejectCallButton:UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 0.5 * 50
        b.clipsToBounds = true
        b.backgroundColor = UIColor.red
        b.setImage(UIImage(named: "hangup"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        b.addTarget(self, action: #selector(rejectCallTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    //UI setup
    func setUpViews(){
        self.addSubview(pickUpCallButton)
        self.addSubview(rejectCallButton)
        
        NSLayoutConstraint.activate([
            
            pickUpCallButton.heightAnchor.constraint(equalToConstant: 50),
            pickUpCallButton.widthAnchor.constraint(equalToConstant: 50),
            pickUpCallButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            pickUpCallButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            
            rejectCallButton.heightAnchor.constraint(equalToConstant: 50),
            rejectCallButton.widthAnchor.constraint(equalToConstant: 50),
            rejectCallButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            rejectCallButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            ])
        
    }
    
    //AVPlayer methods
    func configure(url: String) {
        let videoURL = URL(string: url)
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
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
    @objc func pickUpCallTapped(){
        print("pick up")
    }
    
    @objc func rejectCallTapped(){
        print("reject call")
    }

}
