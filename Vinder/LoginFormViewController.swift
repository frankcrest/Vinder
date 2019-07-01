//
//  LoginFormViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class LoginFormViewController: UIViewController,UITextFieldDelegate {
  
  let ud = UserDefaults.standard
  
  let emailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Email"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let passwordLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Password"
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.borderStyle = UITextField.BorderStyle.none
    tf.textColor = UIColor.pinkColor
    tf.font = UIFont.systemFont(ofSize: 25)
    tf.backgroundColor = .white
    tf.layer.cornerRadius = 10
    tf.tintColor = UIColor.pinkColor
    tf.addPadding(.left(4))
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordTextfield: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.font = UIFont.systemFont(ofSize: 25)
    tf.textColor = UIColor.pinkColor
    tf.borderStyle = UITextField.BorderStyle.none
    tf.layer.cornerRadius = 10
    tf.tintColor = UIColor.pinkColor
    tf.addPadding(.left(4))
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.isSecureTextEntry = true
    return tf
  }()
  
  let loginButton:UIButton = {
    let b = UIButton()
    b.setTitle("Log In", for: .normal)
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.backgroundColor = UIColor.pinkColor
    b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    b.layer.cornerRadius = 25
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    emailTextField.text = ud.string(forKey: "email") ?? ""
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
  }
  
  func setupViews(){
    self.view.backgroundColor = UIColor.yellowColor
    self.view.addSubview(emailLabel)
    self.view.addSubview(passwordLabel)
    self.view.addSubview(emailTextField)
    self.view.addSubview(passwordTextfield)
    self.view.addSubview(loginButton)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
    self.view.addGestureRecognizer(tapGesture)
    
    NSLayoutConstraint.activate([
      emailLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -210),
      emailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      emailLabel.widthAnchor.constraint(equalToConstant: 250),
      emailLabel.heightAnchor.constraint(equalToConstant: 30),
      
      emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 4),
      emailTextField.heightAnchor.constraint(equalToConstant: 40),
      emailTextField.widthAnchor.constraint(equalToConstant: 250),
      
      passwordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 8),
      passwordLabel.widthAnchor.constraint(equalToConstant: 250),
      passwordLabel.heightAnchor.constraint(equalToConstant: 30),
      
      passwordTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      passwordTextfield.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 4),
      passwordTextfield.heightAnchor.constraint(equalToConstant: 40),
      passwordTextfield.widthAnchor.constraint(equalToConstant: 250),
      
      loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      loginButton.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 20),
      loginButton.heightAnchor.constraint(equalToConstant: 50),
      loginButton.widthAnchor.constraint(equalToConstant: 180),
      ])
  }
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.isEmpty == false && passwordTextfield.text?.isEmpty == false
    
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = UIColor.blueColor
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = UIColor.pinkColor
    }
  }
  
  @objc func loginTapped(){
    
    guard let email = emailTextField.text else {return}
    guard let password = passwordTextfield.text else {return}
    
    WebService().logIn(withEmail: email, password: password) { (result, error) in
      
      guard error == nil else {
        print("can not log in with error \(String(describing: error))")
        return
      }
      
      if let uid = result?.user.uid, let email = result?.user.email {
        self.ud.set(uid, forKey: "uid")
        self.ud.set(email, forKey: "email")
      }
      
      self.emailTextField.text = ""
      self.passwordTextfield.text = ""
      UserDefaults.standard.set(true, forKey: "isLoggedIn")
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func screenTapped(){
    self.view.endEditing(true)
  }
  
}
