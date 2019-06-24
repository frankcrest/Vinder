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
  
  let ud = UserDefaults.standard
  
  let emailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Email"
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
    tf.placeholder = "email"
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordTextfield: UITextField = {
    let tf = UITextField()
    tf.placeholder = "password"
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
    b.backgroundColor = .red
    b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
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
    self.view.backgroundColor = .white
    self.view.addSubview(emailLabel)
    self.view.addSubview(passwordLabel)
    self.view.addSubview(emailTextField)
    self.view.addSubview(passwordTextfield)
    self.view.addSubview(loginButton)
    
    NSLayoutConstraint.activate([
      emailLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200),
      emailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      emailLabel.widthAnchor.constraint(equalToConstant: 250),
      emailLabel.heightAnchor.constraint(equalToConstant: 20),
      
      emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 8),
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
      
      self.ud.set(self.emailTextField.text, forKey: "email")
      self.emailTextField.text = ""
      self.passwordTextfield.text = ""
      
      let mapviewController = MapViewController()
        self.present(mapviewController, animated: true, completion: nil)
    }
  }
  
  
  
}
