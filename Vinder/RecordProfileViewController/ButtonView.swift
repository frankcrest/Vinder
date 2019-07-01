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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    //MARK: PROPERTIES
    
    var backButton: UIButton!
    var recordButtonView: RecordButtonView!
    var switchButtonView: UIView!
    var switchCameraButton: UIButton!
    var didFinishRecording: Bool = false
    
    
    private func setupViews() {
        
        /*
         ***************************
         | cancel | record |       |
         ***************************
         */
        
        translatesAutoresizingMaskIntoConstraints = false
        
        func backButtonConfig() {
            backButton = UIButton()
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(.white, for: .normal)
        }
        
        func recordButtonConfig() {
            recordButtonView = RecordButtonView()
        }
        
        func switchButtonViewConfig() {
            switchButtonView = UIView()
            switchButtonView.translatesAutoresizingMaskIntoConstraints = false
            switchButtonView.backgroundColor = .clear
            
            switchCameraButton = UIButton()
            switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
            switchCameraButton.setTitle("Switch", for: .normal)
            switchCameraButton.setTitleColor(.white, for: .normal)
            
            switchButtonView.addSubview(switchCameraButton)
            NSLayoutConstraint.activate([
                switchCameraButton.centerYAnchor.constraint(equalTo: switchButtonView.centerYAnchor),
                switchCameraButton.trailingAnchor.constraint(equalTo: switchButtonView.trailingAnchor, constant: -20)
                ])
            
        }
        
        backButtonConfig()
        recordButtonConfig()
        switchButtonViewConfig()
        
        self.addArrangedSubview(backButton)
        self.addArrangedSubview(recordButtonView)
        self.addArrangedSubview(switchButtonView)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 8.0
        recordButtonView.setupCircleProgressBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       recordButtonView.setupCircleProgressBar()
    }
    
}



