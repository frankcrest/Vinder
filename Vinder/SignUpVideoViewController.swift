//
//  SignUpVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SignUpVideoViewController: UIViewController {
  
  var player = AVPlayer()
  var playerController = AVPlayerViewController()
  
  let containerView:UIView = {
    let v = UIView()
    v.backgroundColor = .blue
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  let promptLabel : UILabel = {
    let label = UILabel()
    label.text = "Take a short 10-15 second introduction video to show your interests & personality"
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 20)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let previousButton:UIButton = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
    return button
  }()
  
  let nextButton:UIButton = {
    let button = UIButton()
    button.setTitle("Next", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    return button
  }()
  
  let videoView:UIView = {
    let v = UIView()
    v.backgroundColor = .white
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  func setupViews(){
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.isHidden = true
    
    self.view.addSubview(containerView)
    self.view.addSubview(promptLabel)
    self.view.addSubview(previousButton)
    self.view.addSubview(nextButton)
    self.view.addSubview(videoView)
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      
      promptLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
      promptLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
      promptLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
      promptLabel.heightAnchor.constraint(equalToConstant: 100),
      
      previousButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
      previousButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
      previousButton.heightAnchor.constraint(equalToConstant: 20),
      previousButton.widthAnchor.constraint(equalToConstant: 100),
      
      nextButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10),
      nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
      nextButton.heightAnchor.constraint(equalToConstant: 20),
      nextButton.widthAnchor.constraint(equalToConstant: 100),
      
      videoView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 0),
      videoView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: 0),
      videoView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, constant: -200),
      videoView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0),
      ])
  }
  
  func playVideo(){
    
  }
  
  @objc func previousTapped(){
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func nextTapped(){
    let recordVideoVC = RecordVideoViewController()
    self.navigationController?.pushViewController(recordVideoVC, animated: true)
  }
  
  
}
