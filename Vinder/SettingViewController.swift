  //
  //  SettingViewController.swift
  //  Vinder
  //
  //  Created by Frank Chen on 2019-06-20.
  //  Copyright © 2019 Frank Chen. All rights reserved.
  //
  
  import UIKit
  
  class SettingViewController: UIViewController {
    
    let backButton : UIButton = {
      let b = UIButton()
      b.backgroundColor = .white
      b.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
      b.translatesAutoresizingMaskIntoConstraints = false
      return b
    }()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      setupViews()
    }
    
    func setupViews(){
      self.view.backgroundColor = .yellow
      
      self.view.addSubview(backButton)
      
      NSLayoutConstraint.activate([
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
        backButton.heightAnchor.constraint(equalToConstant: 50),
        backButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func backTapped(){
      self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
  }
