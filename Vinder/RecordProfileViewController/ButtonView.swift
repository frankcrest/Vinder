//
//  ButtonView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-20.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import UIKit

class ButtonView: UIStackView {
  
  var didFinishRecording: Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.axis = .horizontal
    self.alignment = .center
    self.distribution = .equalSpacing
    self.translatesAutoresizingMaskIntoConstraints = false
    
    setupViews()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  //MARK: PROPERTIES
  
  lazy var backButton : RoundedButton = {
    let b = RoundedButton()
    b.setBackgroundImage(UIImage(named:"back"), for: .normal)
    b.setTitle("Back", for: .normal)
    b.setTitleColor(.clear, for: .normal)
    return b
  }()
  
  lazy var recordButtonView: RecordButtonView = {
    let b = RecordButtonView()
    return b
  }()
  
  lazy var switchCameraButton: RoundedButton = {
    let b = RoundedButton()
    b.setBackgroundImage(UIImage(named:"switch"), for: .normal)
    b.setTitle("Switch", for: .normal)
    b.setTitleColor(.clear, for: .normal)
    return b
  }()
  
  private func setupViews() {
    
    /*
     ***************************
     | cancel | record |       |
     ***************************
     */
    
    self.addArrangedSubview(backButton)
    self.addArrangedSubview(recordButtonView)
    self.addArrangedSubview(switchCameraButton)
    
    recordButtonView.setupCircleProgressBar()
    NSLayoutConstraint.activate([
      
      backButton.widthAnchor.constraint(equalToConstant: 50),
      backButton.heightAnchor.constraint(equalToConstant: 50),
      
      switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
      switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
      
      recordButtonView.widthAnchor.constraint(equalToConstant: 70),
      recordButtonView.heightAnchor.constraint(equalToConstant: 70),
    
      ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    recordButtonView.setupCircleProgressBar()
  }

}



