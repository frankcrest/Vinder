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
    }
    
    //MARK: ACTIONS
    
    
    
    //MARK: UI STUFFS
    
    private func setupVideoViews() {
        remoteVideoView = UIView()
        localVideoView = UIView()
        remoteVideoView.translatesAutoresizingMaskIntoConstraints = false
        localVideoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(remoteVideoView)
        self.view.addSubview(localVideoView)
        
        NSLayoutConstraint.activate([
            remoteVideoView.topAnchor.constraint(equalTo: view.topAnchor),
            remoteVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            remoteVideoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remoteVideoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ])
        
        NSLayoutConstraint.activate([
            localVideoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            localVideoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            localVideoView.widthAnchor.constraint(equalToConstant: 180),
            localVideoView.heightAnchor.constraint(equalToConstant: 240.0)
            ])
        
//        videoView.backgroundColor = .red
        localVideoView.backgroundColor = .black
        
    }
    
    private func setupButtons() {

        switchButton = UIButton()
        switchButton.setTitle("Switch", for: .normal)
        switchButton.addTarget(self, action: #selector(self.joinChannel), for: .touchUpInside)

        hangupButton = UIButton()
        hangupButton.setTitle("Hangup", for: .normal)

        muteButton = UIButton()
        muteButton.setTitle("Mute", for: .normal)

        turnOffCameraButton = UIButton()
        turnOffCameraButton.setTitle("Turn Off", for: .normal)

        NSLayoutConstraint.activate([

            ])

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

//MARK: Setup Engine

extension VideoViewController: AgoraRtcEngineDelegate {
    
    private func initEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
    
    private func setupVideo() {
        agoraKit.enableAudio()
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension1920x1080, frameRate: .fps30, bitrate: AgoraVideoBitrateStandard, orientationMode: .adaptative))
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
        
        print("did join chan")
    }
    
    private func leaveChannel() {
        
        agoraKit.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
    
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
        let remoteVideoCanvas = AgoraRtcVideoCanvas()
        remoteVideoCanvas.uid = uid
        remoteVideoCanvas.view = remoteVideoView
        remoteVideoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(remoteVideoCanvas)
    }
    
    
    
}
