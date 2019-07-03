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
    b.backgroundColor = UIColor.pinkColor
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    b.layer.cornerRadius = 25
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  let signUpButton: UIButton = {
    let b = UIButton()
    b.setTitle("SIGN UP", for: .normal)
    b.backgroundColor = UIColor.blueColor
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    b.layer.cornerRadius = 25
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
    
    self.view.backgroundColor = UIColor.yellowColor
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
      loginInButton.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
      loginInButton.widthAnchor.constraint(equalTo: self.logoView.widthAnchor, multiplier: 0.7),
      
      signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      signUpButton.topAnchor.constraint(equalTo: self.loginInButton.bottomAnchor, constant: 16),
      signUpButton.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
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

extension UIColor {
  static let pinkColor = UIColor(red: 243/255, green: 129/255, blue: 129/255, alpha: 1)
  static let yellowColor = UIColor(red: 255/255, green: 226/255, blue: 111/255, alpha: 1)
  static let blueColor = UIColor(red: 149/255, green: 225/255, blue: 211/255, alpha: 1)
  static let grayColor = UIColor(red: 245/255, green: 255/255, blue: 208/255, alpha: 1)
  static let defaultBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
}

extension UITextField {
  
  enum PaddingSide {
    case left(CGFloat)
    case right(CGFloat)
    case both(CGFloat)
  }
  
  func addPadding(_ padding: PaddingSide) {
    
    self.leftViewMode = .always
    self.layer.masksToBounds = true
    
    
    switch padding {
      
    case .left(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      self.leftView = paddingView
      self.rightViewMode = .always
      
    case .right(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      self.rightView = paddingView
      self.rightViewMode = .always
      
    case .both(let spacing):
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
      // left
      self.leftView = paddingView
      self.leftViewMode = .always
      // right
      self.rightView = paddingView
      self.rightViewMode = .always
    }
  }
}
