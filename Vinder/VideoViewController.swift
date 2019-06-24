//
//  VideoViewController.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit


class VideoViewController: UIViewController {
    
    var remoteVideoView: UIView!
    var localVideoView: UIView!
    
    var switchButton: UIButton!
    var hangupButton: UIButton!
    var muteButton: UIButton!
    var turnOffCameraButton: UIButton!

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
        joinChannel()
    }
    
    //MARK: ACTIONS
    
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
        hangupButton.addTarget(self, action: #selector(self.leaveChannel), for: .touchUpInside)
        
        muteButton = UIButton()
        muteButton.setTitle("Mute", for: .normal)
        muteButton.addTarget(self, action: #selector(self.mute(_:)), for: .touchUpInside)

        turnOffCameraButton = UIButton()
        turnOffCameraButton.setTitle("Turn Off", for: .normal)
        turnOffCameraButton.addTarget(self, action: #selector(self.turnOffCamera(_:)), for: .touchUpInside)



        let buttonStackView = UIStackView(arrangedSubviews: [switchButton, hangupButton,turnOffCameraButton,muteButton])
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
    
    @objc private func joinChannel() {
        
        agoraKit.joinChannel(byToken: nil, channelId: "test", info: nil, uid: 0) { (sid, uid, elapsed) in
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    @objc private func leaveChannel() {
        
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
    }
    
    
    
}
