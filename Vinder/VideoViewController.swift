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

class VideoViewController: UIViewController, UIGestureRecognizerDelegate {
  
  let ref = Database.database().reference()
  let currentUser = Auth.auth().currentUser
  let notificationCenter = NotificationCenter.default
  var remoteVideoView: UIView!
  var localVideoView: UIView!
    var localVideoViewCtn: UIView!
  var userWeAreCalling : String?
  var inCall = false
  
  private let appID = "007d7c78a4cc4fe48b838110bde1cd0c"
  private var agoraKit: AgoraRtcEngineKit!
  
  var switchButton: UIButton!
  var hangupButton: UIButton!
  var muteButton: UIButton!
  var turnOffCameraButton: UIButton!
  var buttonStackView: UIStackView!
  var jokeIndex : Int!
  var swipeRightGesture : UISwipeGestureRecognizer!
  var swipeLeftGesture : UISwipeGestureRecognizer!
  
  let webService = WebService()
    

  
  var jokes : [String] = []
  
  let jokeLabel : UILabel = {
    let l = UILabel()
    l.alpha = 0.3
    l.layer.masksToBounds = true
    l.layer.cornerRadius = 15
    l.backgroundColor = .white
    l.adjustsFontSizeToFitWidth = true
    l.minimumScaleFactor = 0.7
    l.numberOfLines = 0
    l.textAlignment = NSTextAlignment.center
    l.isUserInteractionEnabled = true
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    jokeIndex = 0
    setupVideoViews()
    fetchJokes()
    setupButtons()
    setUpJokeView()
    swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recog:)))
    swipeLeftGesture.direction = .left
    swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recog:)))
    swipeRightGesture.direction = .right
    jokeLabel.addGestureRecognizer(swipeLeftGesture)
    jokeLabel.addGestureRecognizer(swipeRightGesture)
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    agoraKit.stopPreview()
    agoraKit.leaveChannel(nil)
    UIApplication.shared.isIdleTimerDisabled = false
  }
    
    override func viewWillLayoutSubviews() {
        buttonStackView.spacing = (buttonStackView.bounds.size.width - (buttonStackView.bounds.height*4))/3.0
    }
  
  //MARK: ACTIONS
    
  @objc func callResponseReceived(notification:NSNotification){
    print("did receive local notification")
    guard let callResponse = notification.object as? CallResponse else {return}
    print(callResponse.status)
    let tryingToCallUserUid = callResponse.uid
    
    if callResponse.status == .accepted {
      print("the user you are trying to call have accepted your call")
      userWeAreCalling = callResponse.uid
      inCall = true
      leaveChannel()
      joinChannel(uid: tryingToCallUserUid)
    } else if callResponse.status == .rejected {
      print("you have been rejected")
      let uc = UIAlertController(title: "YOU HAVE BEEN REJECTED", message: "YOU WILL BE REDIRECTED TO TINDER FOR DOGS", preferredStyle: .alert)
      let action = UIAlertAction(title: "okay man", style: .cancel) { (action) in
        self.dismiss(animated: true, completion: nil)
      }
      uc.addAction(action)
      self.present(uc, animated: true, completion: nil)
    }else if callResponse.status == .hangup{
      print("they hang up on you")
      let uc = UIAlertController(title: "THEY HANG UP ON YOU", message: "FIND ANOTHER USER TO TALK TO", preferredStyle: .alert)
      let action = UIAlertAction(title: "okay man", style: .cancel) { (action) in
        self.dismiss(animated: true, completion: nil)
      }
      uc.addAction(action)
      self.present(uc, animated: true, completion: nil)
    }
  }
  
  @objc private func mute(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    sender.setImage(UIImage(named: "micon"), for: .selected)
    agoraKit.muteLocalAudioStream(sender.isSelected)
  }
  
  @objc private func switchCamera(_ sender: UIButton) {
    agoraKit.switchCamera()
  }
  
  @objc private func turnOffCamera(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    sender.setImage(UIImage(named: "camon"), for: .selected)
    if sender.isSelected {
      localVideoView.isHidden = true
      agoraKit.disableVideo()
    } else {
      agoraKit.enableVideo()
      localVideoView.isHidden = false
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
    
    let localDefaultImageView = UIImageView()
    localDefaultImageView.image = UIImage(named: "localdefault")
    
    remoteVideoView = UIView()
    localVideoView = UIView()
    localVideoViewCtn = UIView()
    remoteVideoView.translatesAutoresizingMaskIntoConstraints = false
    localVideoView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(remoteVideoView)
    view.addSubview(localVideoViewCtn)
    localVideoViewCtn.addSubview(localDefaultImageView)
    localVideoViewCtn.addSubview(localVideoView)
    
    
    NSLayoutConstraint.activate([
      remoteVideoView.topAnchor.constraint(equalTo: view.topAnchor),
      remoteVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      remoteVideoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      remoteVideoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      ])
    localVideoViewCtn.frame =  CGRect(x: view.bounds.maxX - 170.0 , y: 44.0, width: 150, height: 200)
    localDefaultImageView.frame = CGRect(x: localVideoViewCtn.bounds.midX - localVideoViewCtn.bounds.midX/2,
                                         y: localVideoViewCtn.bounds.midY - localVideoViewCtn.bounds.midY/2,
                                         width: localVideoViewCtn.bounds.midX,
                                         height: localVideoViewCtn.bounds.midY)
    localVideoView.frame = CGRect(x: 0 , y: 0, width: 150, height: 200)
    localVideoViewCtn.layer.cornerRadius = 10
    localVideoViewCtn.layer.masksToBounds = true
    
    remoteVideoView.backgroundColor = .black
    localVideoViewCtn.backgroundColor = .gray
    
    localVideoViewCtn.isUserInteractionEnabled = true
    localVideoViewCtn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveLocalVideoview(_:))))
  }
  
  private func setUpJokeView(){
    self.view.addSubview(jokeLabel)
    
    NSLayoutConstraint.activate([
      jokeLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -10),
      jokeLabel.heightAnchor.constraint(equalToConstant: 60),
      jokeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
      jokeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
      ])
  }
  
  private func setupButtons() {
    
    switchButton = UIButton()
    switchButton.setImage(UIImage(named: "switch2"), for: .normal)
    switchButton.addTarget(self, action: #selector(self.switchCamera(_:)), for: .touchUpInside)
    
    hangupButton = UIButton()
    hangupButton.setImage(UIImage(named: "hangup"), for: .normal)
    hangupButton.addTarget(self, action: #selector(self.hangupTapped), for: .touchUpInside)
    
    muteButton = UIButton()
    muteButton.setImage(UIImage(named: "micoff"), for: .normal)
    muteButton.addTarget(self, action: #selector(self.mute(_:)), for: .touchUpInside)
    
    turnOffCameraButton = UIButton()
    turnOffCameraButton.setImage(UIImage(named: "camoff"), for: .normal)
    turnOffCameraButton.addTarget(self, action: #selector(self.turnOffCamera(_:)), for: .touchUpInside)
    
    buttonStackView = UIStackView(arrangedSubviews: [switchButton, hangupButton,turnOffCameraButton,muteButton])
    buttonStackView.axis = .horizontal
    buttonStackView.distribution = .fillEqually
    buttonStackView.alignment = .center
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
      buttonStackView.heightAnchor.constraint(equalToConstant: 44.0)
      ])
    
    buttonStackView.backgroundColor = .white
  }
  
  func fetchJokes(){
    //initial call
    webService.fetchJokes(completion: { (data) -> (Void) in
      let jokeJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
      guard let joke = jokeJSON!["joke"] else {return}
      self.jokes.append(joke as! String)
      DispatchQueue.main.async {
        self.jokeLabel.text = joke as? String
      }
    })
    
    if jokeIndex != 0{
      jokeIndex += 1
    }
  }
  
  @objc func handleSwipe(recog : UISwipeGestureRecognizer){
    switch recog.direction {
    case .left:
      if(jokeIndex < jokes.count-1){
        print("left")
        jokeIndex += 1
        let joke = jokes[jokeIndex]
        self.jokeLabel.text = joke
      }else {
        fetchJokes()
      }
    case .right:
      if(jokeIndex != 0){
        print("right")
        jokeIndex -= 1
        let joke = jokes[jokeIndex]
        self.jokeLabel.text = joke
      }
    default:
      break
    }
  }
  
  @objc private func joinChannel(uid:String) {
    agoraKit.joinChannel(byToken: nil, channelId: uid, info: nil, uid: 0) { (sid, uid, elapsed) in
      self.agoraKit.setEnableSpeakerphone(true)
      UIApplication.shared.isIdleTimerDisabled = true
    }
  }
  
  @objc func leaveChannel(){
    agoraKit.leaveChannel(nil)
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  @objc private func hangupTapped() {
    guard let user = currentUser else {return}
    if inCall == false {
      self.ref.child("calling").child(user.uid).removeValue()
      self.dismiss(animated: true, completion: nil)
    }else if inCall == true{
      guard let otherUser = userWeAreCalling else {return}
      ref.child("hangup").child(otherUser).setValue([user.uid : 1])
      inCall = false
      self.dismiss(animated: true, completion: nil)
    }
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
  
  @objc func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
    
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

