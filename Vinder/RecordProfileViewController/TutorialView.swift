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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        
    }
    
    let promptLabel : UILabel = {
        let label = UILabel()
        label.text = "Take a short 10-15 second introduction video to show your interests & personality"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let replayButton:UIButton = {
        let button = UIButton()
        button.setTitle("Replay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(replayTapped), for: .touchUpInside)
        return button
    }()
    
    let gotItButton:UIButton = {
        let button = UIButton()
        button.setTitle("GOT IT!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(gotItTapped), for: .touchUpInside)
        return button
    }()
    
    func setupViews(){
        
        self.addSubview(promptLabel)
        self.addSubview(replayButton)
        self.addSubview(gotItButton)
        
        NSLayoutConstraint.activate([
            
            promptLabel.topAnchor.constraint(equalTo: self.topAnchor),
            promptLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            promptLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            promptLabel.heightAnchor.constraint(equalToConstant: 100),
            
            replayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            replayButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            replayButton.heightAnchor.constraint(equalToConstant: 20),
            replayButton.widthAnchor.constraint(equalToConstant: 100),
            
            gotItButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            gotItButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            gotItButton.heightAnchor.constraint(equalToConstant: 20),
            gotItButton.widthAnchor.constraint(equalToConstant: 100),
            
            ])
    }
    
    
    @objc func gotItTapped() {
        
        
    }
    
    @objc func replayTapped() {
        
    }
    
    
    
    
    
}
