//
//  RecordVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class RecordVideoViewController: UIViewController {
  
    //MARK: UI VIEW PROPERTIES
    
  let recordPreviewView:UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = .blue
    return v
  }()
  
  let recordButton:UIButton = {
    let button = UIButton()
    button.setTitle("RRR", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let cancleButton:UIButton = {
    let button = UIButton()
    button.setTitle("CC", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(cancleTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let retakeVideoButton: UIButton = {
    let button = UIButton()
    button.setTitle("RT", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("confirm", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
    
    //MARK: PROPERTIES
    
    let cameraController = CameraController()
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    //MARK: ViewWDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    configureCameraController()
    
    
  }
    //MARK: CAMERACONTROLLER
    
    func configureCameraController() {
        cameraController.prepare { (error) in
            if let error = error {
                print("can not configure camera controller: \(error)")
            }
            try? self.cameraController.displayPreview(on: self.recordPreviewView)
        }
    }
    
    //MARK: VIDEO REVIEW
    
    func configureReview() {
        let videoUrl = cameraController.fileURL
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = self.playerLayer {
            view.layer.addSublayer(playerLayer)
            playerLayer.frame = view.layer.frame
        }
        player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player?.play()
        }
    }
    
    
    
    //MARK: SETUP VIEWS
  
  func setupViews(){
    self.view.addSubview(recordPreviewView)
    self.view.addSubview(recordButton)
    self.view.addSubview(cancleButton)
    self.view.addSubview(retakeVideoButton)
    self.view.addSubview(confirmButton)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.isHidden = true
    
    NSLayoutConstraint.activate([
      recordPreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      recordPreviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      recordPreviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      recordPreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      
      recordButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      recordButton.heightAnchor.constraint(equalToConstant: 50),
      recordButton.widthAnchor.constraint(equalToConstant: 50),
      
      cancleButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      cancleButton.trailingAnchor.constraint(equalTo: self.recordButton.leadingAnchor, constant: -30),
      cancleButton.heightAnchor.constraint(equalToConstant: 50),
      cancleButton.widthAnchor.constraint(equalToConstant: 50),
      
      confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100),
      confirmButton.heightAnchor.constraint(equalToConstant: 50),
      confirmButton.widthAnchor.constraint(equalToConstant: 50),
      
      retakeVideoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      retakeVideoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -120),
      retakeVideoButton.heightAnchor.constraint(equalToConstant: 50),
      retakeVideoButton.widthAnchor.constraint(equalToConstant: 50),
      ])
  }
    
    //MARK: ACTIONS
  
  @objc func recordTapped(){
    print("recording")
    cameraController.startRecording()
  }
  
  @objc func cancleTapped(){
    cameraController.stopRecording()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.cameraController.removePreview()
        self.configureReview()
    }
    
  }
  
  @objc func retakeButtonTapped(){
    do {
        try cameraController.switchCameras()
    } catch {
        print("can not swict camera: \(error)")
    }
    
  }
  
  @objc func confirmTapped(){
    
  }
  
}

extension RecordVideoViewController {
    
    

    
   
    
    
    
}
