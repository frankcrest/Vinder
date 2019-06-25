//
//  VideoViewController.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit
import Firebase

class VideoViewController: UIViewController {
  
  let ref = Database.database().reference()
  let currentUser = Auth.auth().currentUser
  let notificationCenter = NotificationCenter.default
  var remoteVideoView: UIView!
  var localVideoView: UIView!
  
  var switchButton: UIButton!
  var hangupButton: UIButton!
  var muteButton: UIButton!
  var turnOffCameraButton: UIButton!
  var buttonStackView: UIStackView!
  
  private let appID = "007d7c78a4cc4fe48b838110bde1cd0c"
  private var agoraKit: AgoraRtcEngineKit!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupVideoViews()
    setupButtons()
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    initEngine()
    setupVideo()
    setupLocalVideoCanvas()
    agoraKit.startPreview()
    
    notificationCenter.addObserver(self, selector: #selector(callResponseReceived), name: NSNotification.Name.CallResponseNotification, object: nil)
    //join my channel
    guard let userUid = currentUser?.uid else {return}
    joinChannel(uid: userUid)
  }
  
  //MARK: ACTIONS
  @objc func callResponseReceived(notification:NSNotification){
    print("did receive local notification")
    guard let callResponse = notification.object as? CallResponse else {return}
    print(callResponse.status)
    let tryingToCallUserUid = callResponse.uid
    
    if callResponse.status == .accepted {
      ref.child("callAccepted").child(callResponse.uid).removeValue()
      print("the user you are trying to call have accepted your call")
      leaveChannel()
      joinChannel(uid: tryingToCallUserUid)
    } else {
      ref.child("callRejected").child(callResponse.uid).removeValue()
      let uc = UIAlertController(title: "You have been rejected", message: "rejected", preferredStyle: .alert)
      let action = UIAlertAction(title: "okay man", style: .cancel, handler: nil)
      uc.addAction(action)
      self.present(uc, animated: true, completion: nil)
      print("the user you are trying to call have rejected your call")
    }
   
  }
  
  @objc private func mute(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    agoraKit.muteLocalAudioStream(sender.isSelected)
  }
  
  @objc private func switchCamera(_ sender: UIButton) {
    agoraKit.switchCamera()
  }
  
  @objc private func turnOffCamera(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    if sender.isSelected {
      agoraKit.disableVideo()
    } else {
      agoraKit.enableVideo()
    }
    
    agoraKit.muteLocalVideoStream(sender.isSelected)
    
  }
  
  @objc private func moveLocalVideoview(_ sender: UIPanGestureRecognizer) {
    
    let translation = sender.translation(in: view)
    if let oldCenter = sender.view?.center {
      let newCenter = CGPoint(x: oldCenter.x + translation.x, y: oldCenter.y + translation.y)
      sender.view?.center = newCenter
    }
    sender.setTranslation(CGPoint.zero, in: view)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if buttonStackView.isHidden {
      buttonStackView.isHidden = false
      UIView.animate(withDuration: 0.3, animations: {
        self.buttonStackView.alpha = 1
      }) { (_) in
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          UIView.animate(withDuration: 0.3, animations: {
            self.buttonStackView.alpha = 0
          }) { (_) in
            self.buttonStackView.isHidden = true
          }
        }
      }
    }
  }
  
  
  
  
  
  //MARK: UI SETUPS
  
  private func setupVideoViews() {
    remoteVideoView = UIView()
    localVideoView = UIView()
    remoteVideoView.translatesAutoresizingMaskIntoConstraints = false
    localVideoView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(remoteVideoView)
    view.addSubview(localVideoView)
    
    NSLayoutConstraint.activate([
      remoteVideoView.topAnchor.constraint(equalTo: view.topAnchor),
      remoteVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      remoteVideoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      remoteVideoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      ])
    
    localVideoView.frame = CGRect(x: view.bounds.maxX - 170.0 , y: 44.0, width: 150, height: 200)
    localVideoView.layer.cornerRadius = 10
    localVideoView.layer.masksToBounds = true
    
    remoteVideoView.backgroundColor = .black
    localVideoView.backgroundColor = .black
    
    localVideoView.isUserInteractionEnabled = true
    localVideoView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveLocalVideoview(_:))))
    
  }
  
  private func setupButtons() {
    
    switchButton = UIButton()
    switchButton.setTitle("Switch", for: .normal)
    switchButton.addTarget(self, action: #selector(self.switchCamera(_:)), for: .touchUpInside)
    
    hangupButton = UIButton()
    hangupButton.setTitle("Hangup", for: .normal)
    hangupButton.addTarget(self, action: #selector(self.hangupTapped), for: .touchUpInside)
    
    muteButton = UIButton()
    muteButton.setTitle("Mute", for: .normal)
    muteButton.addTarget(self, action: #selector(self.mute(_:)), for: .touchUpInside)
    
    turnOffCameraButton = UIButton()
    turnOffCameraButton.setTitle("Turn Off", for: .normal)
    turnOffCameraButton.addTarget(self, action: #selector(self.turnOffCamera(_:)), for: .touchUpInside)
    
    
    
    buttonStackView = UIStackView(arrangedSubviews: [switchButton, hangupButton,turnOffCameraButton,muteButton])
    buttonStackView.axis = .horizontal
    buttonStackView.distribution = .fillEqually
    buttonStackView.alignment = .fill
    buttonStackView.spacing = 8.0
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
      buttonStackView.heightAnchor.constraint(equalToConstant: 44.0)
      ])
    
    buttonStackView.backgroundColor = .white
    
  }
  
  
  
  
}

//MARK: AGORA ENGINE SET UP

extension VideoViewController: AgoraRtcEngineDelegate {
  
  private func initEngine() {
    agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
  }
  
  private func setupVideo() {
    agoraKit.enableAudio()
    agoraKit.enableVideo()
    agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension1280x720, frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative))
  }
  
  private func setupLocalVideoCanvas() {
    
    let localVideoCanvas = AgoraRtcVideoCanvas()
    localVideoCanvas.uid = 0
    localVideoCanvas.renderMode = .hidden
    localVideoCanvas.view = localVideoView
    agoraKit.setupLocalVideo(localVideoCanvas)
  }
  
  @objc private func joinChannel(uid:String) {
    agoraKit.joinChannel(byToken: nil, channelId: uid, info: nil, uid: 0) { (sid, uid, elapsed) in
      self.agoraKit.setEnableSpeakerphone(true)
      UIApplication.shared.isIdleTimerDisabled = true
    }
  }
  
  @objc private func hangupTapped() {
    guard let user = currentUser else {return}
    ref.child("calling").child(user.uid).removeValue()
    agoraKit.leaveChannel(nil)
    UIApplication.shared.isIdleTimerDisabled = false
    self.dismiss(animated: true, completion: nil)
  }
  
  func leaveChannel(){
    agoraKit.leaveChannel(nil)
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
    
    let remoteVideoCanvas = AgoraRtcVideoCanvas()
    remoteVideoCanvas.uid = uid
    remoteVideoCanvas.view = remoteVideoView
    remoteVideoCanvas.renderMode = .hidden
    agoraKit.setupRemoteVideo(remoteVideoCanvas)
    view.bringSubviewToFront(localVideoView)
    
    //hide control buttons
    
    UIView.animate(withDuration: 0.3, animations: {
      self.buttonStackView.alpha = 0
    }) { (_) in
      self.buttonStackView.isHidden = true
    }
  }
  
  
  
}
