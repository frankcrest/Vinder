//
//  ProfileView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-01.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import Lottie
import AVKit
import AVFoundation


class ProfileView: RoundedCornerView {
    
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var isLoop: Bool = false
    let ws = WebService()
    
    var videoURL: String? {
        didSet {
            configureView()
        }
    }
    
    var username: String? {
        didSet {
            nameLabel.text = username
        }
    }
    
    //  private var circleLayer = CAShapeLayer()
    
    let videoContainer: RoundedCornerView = {
        let v = RoundedCornerView()
        v.backgroundColor = .white
        v.layer.masksToBounds = true
        return v
    }()
    
    let videoView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let infoContainer: RoundedCornerView = {
        let v = RoundedCornerView()
        let yellowColor = UIColor(red: 255/255, green: 226/255, blue: 111/255, alpha: 1)
        v.backgroundColor = yellowColor
        return v
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonContainer:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        sv.alignment = .center
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let leftButton: RoundedRectButton = {
        let b = RoundedRectButton()
        let blueColor = UIColor(red: 149/255, green: 225/255, blue: 211/255, alpha: 1)
        b.backgroundColor = blueColor
        b.setTitle("Message", for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    let rightButton:RoundedRectButton = {
        let b = RoundedRectButton()
        let pinkColor = UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1)
        b.backgroundColor = pinkColor
        b.setTitle("Call", for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    
    let heartButton:RoundedButton = {
        let b = RoundedButton()
        b.backgroundColor = .clear
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    let dissmissButton: RoundedButton = {
       let b = RoundedButton()
        b.backgroundColor = .clear
        b.setImage(UIImage(named: "dismiss"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        return b
    }()
    
    let lottieView = AnimationView(name: "simple")

    
    
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
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
        centerYCons?.constant = bounds.height*1.0/5.0
    }
    var centerYCons: NSLayoutConstraint?
    
    //UI setup
    func setUpViews(){
        
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(videoContainer)
        videoContainer.addSubview(videoView)
        videoView.addSubview(lottieView)
        
        addSubview(infoContainer)
        infoContainer.addSubview(nameLabel)
        
        addSubview(buttonContainer)
        
        self.buttonContainer.addArrangedSubview(leftButton)
        self.buttonContainer.addArrangedSubview(rightButton)
        
        addSubview(heartButton)
        
        addSubview(dissmissButton)
        
        centerYCons = videoContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            
            videoContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3.0/4.0),
            videoContainer.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 3.0/4.0),
            centerYCons!,
            videoContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            videoView.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor),
            videoView.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor),
            videoView.widthAnchor.constraint(equalTo: videoContainer.widthAnchor),
            videoView.heightAnchor.constraint(equalTo: videoContainer.heightAnchor),
            
            lottieView.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 150),
            lottieView.heightAnchor.constraint(equalToConstant: 150),
            
            infoContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoContainer.widthAnchor.constraint(equalTo: videoContainer.widthAnchor),
            infoContainer.heightAnchor.constraint(equalTo: videoContainer.widthAnchor, multiplier: 1.0/5.0),
            infoContainer.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: infoContainer.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: infoContainer.centerXAnchor),
            
            heartButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: 66),
            heartButton.heightAnchor.constraint(equalToConstant: 66),
            heartButton.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: 40),
            
            buttonContainer.topAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: 40),
            buttonContainer.widthAnchor.constraint(equalTo: videoContainer.widthAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            leftButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 0.45),
            leftButton.heightAnchor.constraint(equalToConstant: 44),
            rightButton.heightAnchor.constraint(equalToConstant: 44),
            rightButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 0.45),
            
            dissmissButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dissmissButton.widthAnchor.constraint(equalToConstant: 66),
            dissmissButton.heightAnchor.constraint(equalToConstant: 66),
            dissmissButton.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: 33),
            
            
            ])
        
        lottieView.loopMode = .loop
        lottieView.play()
        
    }
    
    
    func configureView() {
        
        if let url = videoURL {
            WebService().fetchProfileVideo(at: url) { (url, err) -> (Void) in
                guard err == nil, let url = url else { return }
                DispatchQueue.main.async {
                    self.player = AVPlayer(url: url)
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer.frame = self.videoContainer.frame
                    self.layer.addSublayer(self.playerLayer)
                    self.player.play()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
                }
            }
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player?.play()
        }
    }

    func stop() {
        
        if player != nil {
            playerLayer.removeFromSuperlayer()
            player.pause()
            player = nil
        }
        
    }
    

    
}
