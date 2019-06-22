
//  RecordVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAuth
import FirebaseDatabase


class RecordVideoViewController: UIViewController {
    
    //MARK: UI VIEW PROPERTIES
    
    let recordPreviewView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //TODO: NEED TO CHANGE BACKGROUND
        view.backgroundColor = .black
        return view
    }()
    
    
    //MARK: PROPERTIES
    
    var ref = Database.database().reference()
    let ud = UserDefaults.standard
    let cameraController = CameraController()
    var buttonView = ButtonView()
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    //MARK: ViewWDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.startAnimationDelegate = self
        setupViews()
        configureCameraController()
        buttonView.recordButtonView.videoHandlerDelegate = self
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.isHidden = true
  }
    //MARK: CAMERA CONTROLLER
    
    func configureCameraController() {
        cameraController.prepare { (error) in
            if let error = error {
                print("can not configure camera controller: \(error)")
            }
            try? self.cameraController.displayPreview(on: self.recordPreviewView)
        }
    }
    
    //MARK: SETUP VIEWS
    
    func setupViews(){
        
        view.addSubview(recordPreviewView)
        view.addSubview(buttonView)
        
        buttonView.switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        buttonView.backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 1/12),
            buttonView.widthAnchor.constraint(equalToConstant: view.frame.width),
            buttonView.heightAnchor.constraint(equalToConstant: view.frame.height * 1/12),
            
            recordPreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            recordPreviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            recordPreviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            recordPreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
            ])
        
    }
    
    //MARK: ACTIONS
    
    @objc func switchCamera(){
      let mapVC = MapViewController()
      self.present(mapVC, animated: true, completion: nil)
//        do {
//            try cameraController.switchCameras()
//        } catch {
//            print("can not swict camera: \(error)")
//        }
    }
    
    
    @objc func backButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "back" {
          self.navigationController?.popViewController(animated: true)
        }
        
        if sender.titleLabel?.text == "retake" {
            sender.setTitle("back", for: .normal)
            player?.pause()
            player = nil
            self.playerLayer?.removeFromSuperlayer()
            self.configureCameraController()
        }
    }
    
    @objc func confirmTapped(){
        guard let email = ud.string(forKey: "email") else {return}
        guard let password = ud.string(forKey: "password") else {return}
        guard let name = ud.string(forKey: "name") else {return}
        guard let username = ud.string(forKey: "username") else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print(error)
                return
            }
            guard let uid = user?.user.uid else {return}
            self.ref.child("users").child(uid).setValue((["email":email, "username":username, "name":name]), withCompletionBlock: { (error, ref) in
                if let error = error{
                    print(error)
                    return
                }
                let mapViewVC = MapViewController()
                self.present(mapViewVC, animated: true, completion: nil)
            })
        }
    }
}

//MARK: VIDEO RELATED

extension RecordVideoViewController: VideoHandlerDelegate, StartAnimationDelegate {
    
    //MARK: VIDEO REVIEW
    
    func configureReview() {
        let videoUrl = cameraController.fileURL
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = self.playerLayer {
            view.layer.insertSublayer(playerLayer, at: 1)
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
    
    func startRecording() {
        cameraController.startRecording()
    }
    
    func stopRecording(){
        cameraController.stopRecording()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cameraController.removePreview()
            self.configureReview()
            self.buttonView.backButton.setTitle("retake", for: .normal)
        }
    }
    
    func startAnimation() {
        buttonView.recordButtonView.startAnimation()
    }
    
    
    
}


