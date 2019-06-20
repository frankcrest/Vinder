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
    var spaceView: UIView!
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
            backButton.setTitle("back", for: .normal)
            backButton.setTitleColor(.white, for: .normal)
        }
        
        func recordButtonConfig() {
            recordButtonView = RecordButtonView()
        }
        
        func spaccViewConfig() {
            spaceView = UIView()
            spaceView.translatesAutoresizingMaskIntoConstraints = false
            spaceView.backgroundColor = .clear
        }
        
        backButtonConfig()
        recordButtonConfig()
        spaccViewConfig()
        
        self.addArrangedSubview(backButton)
        self.addArrangedSubview(recordButtonView)
        self.addArrangedSubview(spaceView)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 8.0
//        if !didFinishRecording {
            recordButtonView.setupCircleProgressBar()
//        }
            }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if !didFinishRecording {
            recordButtonView.setupCircleProgressBar()
//        }
        
    }
    
}



