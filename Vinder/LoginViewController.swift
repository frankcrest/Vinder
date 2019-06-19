//
//  ViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  let logoView:UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.image = UIImage(named: "logo")
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  let loginInButton: UIButton = {
    let b = UIButton()
    b.setTitle("LOG IN", for: .normal)
    b.backgroundColor = .magenta
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  let signUpButton: UIButton = {
    let b = UIButton()
    b.setTitle("SIGN UP", for: .normal)
    b.backgroundColor = .cyan
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupViews()
  }
  
  func setupViews(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    self.view.backgroundColor = .white
    self.view.addSubview(logoView)
    self.view.addSubview(loginInButton)
    self.view.addSubview(signUpButton)
    
    NSLayoutConstraint.activate([
      logoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
      logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      logoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
      logoView.widthAnchor.constraint(equalTo: self.logoView.heightAnchor, multiplier: 1),
      
      loginInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      loginInButton.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 100),
      loginInButton.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
      loginInButton.widthAnchor.constraint(equalTo: self.logoView.widthAnchor, multiplier: 0.7),
      
      signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      signUpButton.topAnchor.constraint(equalTo: self.loginInButton.bottomAnchor, constant: 16),
      signUpButton.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
      signUpButton.widthAnchor.constraint(equalTo: self.logoView.widthAnchor, multiplier: 0.7),
      ])
  }
  
  @objc func loginTapped(){
   let loginVC = LoginFormViewController()
    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
  @objc func signUpTapped(){
    let signupVC = SignUpViewController()
    self.navigationController?.pushViewController(signupVC, animated: true)
  }
  
}

