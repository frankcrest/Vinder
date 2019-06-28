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
  
  var videoURL: String?
  var username: String?
  
  private var circleLayer = CAShapeLayer()
  
  let buttonContainer:UIStackView = {
    let sv = UIStackView()
    sv.axis = .horizontal
    sv.distribution = .equalSpacing
    sv.alignment = .center
    sv.backgroundColor = .white
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  let videoContainer:UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  let leftButton:UIButton = {
    let b = UIButton()
    b.layer.cornerRadius = 25
    b.clipsToBounds = true
    b.backgroundColor = .green
    b.imageView?.contentMode = .scaleAspectFit
    b.translatesAutoresizingMaskIntoConstraints = false
    b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    return b
  }()
  
  let rightButton:UIButton = {
    let b = UIButton()
    b.layer.cornerRadius = 25
    b.clipsToBounds = true
    b.backgroundColor = .green
    b.imageView?.contentMode = .scaleAspectFit
    b.translatesAutoresizingMaskIntoConstraints = false
    b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    return b
  }()
  
  
  let heartButton:UIButton = {
    let b = UIButton()
    b.layer.cornerRadius = 25
    b.clipsToBounds = true
    b.backgroundColor = UIColor(red: 234/255, green: 125/255, blue: 199/255, alpha: 1)
    b.imageView?.contentMode = .scaleAspectFit
    b.translatesAutoresizingMaskIntoConstraints = false
    b.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    return b
  }()
  
  var percentageLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.text = ""
    label.textColor = .purple
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpViews()
  }
  
  
  //UI setup
  func setUpViews(){
    
    self.addSubview(buttonContainer)
    self.addSubview(videoContainer)
    self.buttonContainer.addArrangedSubview(leftButton)
    self.buttonContainer.addArrangedSubview(heartButton)
    self.buttonContainer.addArrangedSubview(rightButton)
    
    self.addSubview(percentageLabel)
    setupCircleProgressBar()
    self.layer.addSublayer(circleLayer)
    self.circleLayer.isHidden = true
    self.percentageLabel.isHidden = true
    
    NSLayoutConstraint.activate([
      
      leftButton.heightAnchor.constraint(equalToConstant:  50),
      leftButton.widthAnchor.constraint(equalToConstant: 50),
      
      rightButton.heightAnchor.constraint(equalToConstant:  50),
      rightButton.widthAnchor.constraint(equalToConstant: 50),
      
      heartButton.heightAnchor.constraint(equalToConstant:  50),
      heartButton.widthAnchor.constraint(equalToConstant: 50),
      buttonContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
      buttonContainer.heightAnchor.constraint(equalToConstant: 50),
      buttonContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      buttonContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      
      videoContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      videoContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
      videoContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      videoContainer.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -4),
      
      percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
    
  }
  
  
  func configureView() {
    guard let videoURL = videoURL else { return }
    guard let url = URL(string: videoURL) else { return }
    player = AVPlayer(url: url)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = self.videoContainer.frame
    self.layer.addSublayer(playerLayer)
    player.play()
  }
  
  func play() {
    self.circleLayer.isHidden = true
    self.percentageLabel.isHidden = true
    if player.timeControlStatus != AVPlayer.TimeControlStatus.playing {
      player.play()
    }
  }
  
  func pause() {
    player.pause()
  }
  
  func stop() {
    //player.pause()
    //player.seek(to: CMTime.zero)
  }
  
  @objc func reachTheEndOfTheVideo(_ notification: Notification) {
    if isLoop {
      player.pause()
      player.seek(to: CMTime.zero)
      player.play()
    }
  }
}

extension VideoView: CAAnimationDelegate, UpdateProgressDelegate {
  
  func setupCircleProgressBar() {
    
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    let radius = self.bounds.height/8.0
    let circularPath = UIBezierPath(arcCenter: center, radius: radius , startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
    
    circleLayer.frame = self.bounds
    circleLayer.path = circularPath.cgPath
    circleLayer.strokeColor = UIColor.purple.cgColor
    circleLayer.lineWidth = 5
    circleLayer.fillColor = UIColor.clear.cgColor
    circleLayer.lineCap = CAShapeLayerLineCap.round
    circleLayer.strokeEnd = 0
    
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
  }
  
  func updateProgress(progress: Double) {
    self.circleLayer.isHidden = false
    self.percentageLabel.isHidden = false
    percentageLabel.text = "\(round(progress))%"
    circleLayer.isHidden = false
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.delegate = self
    basicAnimation.toValue = progress/100.0
    basicAnimation.fillMode = CAMediaTimingFillMode.forwards
    basicAnimation.isRemovedOnCompletion = false
    circleLayer.add(basicAnimation, forKey: "animate")
  }
  
}
