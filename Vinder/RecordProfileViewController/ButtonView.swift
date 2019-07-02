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
    
    var backButton: RoundedButton!
    var recordButtonView: RecordButtonView!
    var switchCameraButton: RoundedButton!
    var didFinishRecording: Bool = false
    var backBtnCtn = UIView()
    var switchBtnCtn = UIView()
    
    private func setupViews() {
        
        /*
         ***************************
         | cancel | record |       |
         ***************************
         */
        
        translatesAutoresizingMaskIntoConstraints = false
        
        func backButtonConfig() {
            backButton = RoundedButton()
            backButton.setImage(UIImage(named: "back"), for: .normal)
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(.clear, for: .normal)
            backBtnCtn.backgroundColor = .clear
            backBtnCtn.translatesAutoresizingMaskIntoConstraints = false
            backBtnCtn.addSubview(backButton)
        }
        
        func recordButtonConfig() {
            recordButtonView = RecordButtonView()
        }
        
        func switchButtonViewConfig() {
            switchCameraButton = RoundedButton()
            switchCameraButton.setImage(UIImage(named: "switch"), for: .normal)
            switchCameraButton.setTitle("Switch", for: .normal)
            switchCameraButton.setTitleColor(.clear, for: .normal)
            switchBtnCtn.backgroundColor = .clear
            switchBtnCtn.translatesAutoresizingMaskIntoConstraints = false
            switchBtnCtn.addSubview(switchCameraButton)
        }
        
        backButtonConfig()
        recordButtonConfig()
        switchButtonViewConfig()
        
        addArrangedSubview(backBtnCtn)
        addArrangedSubview(recordButtonView)
        addArrangedSubview(switchBtnCtn)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        recordButtonView.setupCircleProgressBar()
        NSLayoutConstraint.activate([
            
            switchBtnCtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/3.0),
            switchBtnCtn.heightAnchor.constraint(equalTo: heightAnchor),
            
            backBtnCtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/3.0),
            backBtnCtn.heightAnchor.constraint(equalTo: heightAnchor),

            recordButtonView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/3.0),
            recordButtonView.heightAnchor.constraint(equalTo: heightAnchor),
            
            switchCameraButton.heightAnchor.constraint(equalTo: switchBtnCtn.heightAnchor, multiplier: 0.9),
            switchCameraButton.widthAnchor.constraint(equalTo: switchCameraButton.heightAnchor),
            switchCameraButton.centerYAnchor.constraint(equalTo: switchBtnCtn.centerYAnchor),
            switchCameraButton.centerXAnchor.constraint(equalTo: switchBtnCtn.centerXAnchor),
            
            backButton.heightAnchor.constraint(equalTo: backBtnCtn.heightAnchor, multiplier: 0.9),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            backButton.centerYAnchor.constraint(equalTo: backBtnCtn.centerYAnchor),
            backButton.centerXAnchor.constraint(equalTo: backBtnCtn.centerXAnchor),
            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       recordButtonView.setupCircleProgressBar()
    }
    
}



