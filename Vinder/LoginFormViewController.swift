//
//  LoginFormViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginFormViewController: UIViewController,UITextFieldDelegate {
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Username"
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let passwordLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Password"
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "username"
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordTextfield: UITextField = {
    let tf = UITextField()
    tf.placeholder = "password"
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let loginButton:UIButton = {
    let b = UIButton()
    b.setTitle("Log In", for: .normal)
    b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    b.setTitleColor(.white, for: .normal)
    b.backgroundColor = .red
    b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  func setupViews(){
    self.view.backgroundColor = .white
    self.view.addSubview(usernameLabel)
    self.view.addSubview(passwordLabel)
    self.view.addSubview(emailTextField)
    self.view.addSubview(passwordTextfield)
    self.view.addSubview(loginButton)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    NSLayoutConstraint.activate([
      usernameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200),
      usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      usernameLabel.widthAnchor.constraint(equalToConstant: 250),
      usernameLabel.heightAnchor.constraint(equalToConstant: 20),
      
      emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      emailTextField.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 8),
      emailTextField.heightAnchor.constraint(equalToConstant: 20),
      emailTextField.widthAnchor.constraint(equalToConstant: 250),
      
      passwordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 8),
      passwordLabel.widthAnchor.constraint(equalToConstant: 250),
      passwordLabel.heightAnchor.constraint(equalToConstant: 20),
      
      passwordTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      passwordTextfield.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 8),
      passwordTextfield.heightAnchor.constraint(equalToConstant: 20),
      passwordTextfield.widthAnchor.constraint(equalToConstant: 250),
      
      loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      loginButton.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 20),
      loginButton.heightAnchor.constraint(equalToConstant: 30),
      loginButton.widthAnchor.constraint(equalToConstant: 180),
      ])
  }
  
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.isEmpty == false && passwordTextfield.text?.isEmpty == false
    
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = .blue
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = .red
    }
  }
  
  @objc func loginTapped(){
    guard let email = emailTextField.text else {return}
    guard let password = passwordTextfield.text else {return}
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if let error = error{
        print(error)
        return
      }
      //segue to map
    }
  }
  
  
  
}
