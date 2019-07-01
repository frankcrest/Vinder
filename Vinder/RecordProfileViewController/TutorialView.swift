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
    
    let promptLabel : UILabel = {
        let label = UILabel()
        label.text = "Take A Short 10 To 15 Second Intro Video To Show Your Personality & Interests"
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
        return button
    }()
    
    let gotItButton:UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
     let stackView = UIStackView()
    
    func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        stackView.addArrangedSubview(replayButton)
        stackView.addArrangedSubview(gotItButton)
        addSubview(promptLabel)
        addSubview(stackView)

       setupStackView()

        
        
        NSLayoutConstraint.activate([

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
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.widthAnchor.constraint(equalTo: widthAnchor)
            //problem here
            
            ])
    }

    
}
