//
//  TutorialView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-21.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class TutorialView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupStackView()
  }
    
    let tutorialVideoView: UIView = {
       let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
  
  let promptLabel : UILabel = {
    let label = UILabel()
    label.text = "You're almost there!"
//    Take A Short 10 To 15 Second Intro Video To Show Your Personality & Interests
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let replayButton:RoundedRectButton = {
    let button = RoundedRectButton()
    button.setTitle("Replay", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .blueColor
    return button
  }()
  
  let gotItButton:RoundedRectButton = {
    let button = RoundedRectButton()
    button.setTitle("Next", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .pinkColor
    return button
  }()
  
  let stackView = UIStackView()
  
  func setupViews(){
    backgroundColor = .black
    translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(replayButton)
    stackView.addArrangedSubview(gotItButton)
    addSubview(tutorialVideoView)
    addSubview(promptLabel)
    addSubview(stackView)
    
    setupStackView()
    
    NSLayoutConstraint.activate([
        
        tutorialVideoView.centerXAnchor.constraint(equalTo: centerXAnchor),
        tutorialVideoView.centerYAnchor.constraint(equalTo: centerYAnchor),
        tutorialVideoView.widthAnchor.constraint(equalTo: widthAnchor),
        tutorialVideoView.heightAnchor.constraint(equalTo: heightAnchor),
      
      promptLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
      promptLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
      promptLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
      promptLabel.heightAnchor.constraint(equalToConstant: 100),
      
      ])
  }
  
  func setupStackView() {
    
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    
    NSLayoutConstraint.activate([
      
      stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -88),
      stackView.heightAnchor.constraint(equalToConstant: 66),
      stackView.widthAnchor.constraint(equalTo: widthAnchor,constant: -32)
      //problem here
      
      ])
  }
  
  
}
