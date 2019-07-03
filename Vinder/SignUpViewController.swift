//
//  LoginFormViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    let ud = UserDefaults.standard
    var topConstraint : NSLayoutConstraint!
    
    let welcomeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Welcome"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Tell Us Your Email"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Choose Your Username"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Tell Us Your Name"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Choose A Password"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
//        tf.text = "testemail\(arc4random_uniform(99))@email.com"
        tf.borderStyle = UITextField.BorderStyle.none
        tf.textColor = UIColor.pinkColor
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.addPadding(.left(4))
        tf.tintColor = UIColor.pinkColor
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameTextfield: UITextField = {
        let tf = UITextField()
//        tf.text = "testuser\(arc4random_uniform(99))"
        tf.borderStyle = UITextField.BorderStyle.none
        tf.textColor = UIColor.pinkColor
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.addPadding(.left(4))
        tf.tintColor = UIColor.pinkColor
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameTextfield: UITextField = {
        let tf = UITextField()
//        tf.text = "testuser\(arc4random_uniform(99))"
        tf.borderStyle = UITextField.BorderStyle.none
        tf.textColor = UIColor.pinkColor
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.addPadding(.left(4))
        tf.tintColor = UIColor.pinkColor
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextfield: UITextField = {
        let tf = UITextField()
//        tf.text = "123456"
        tf.isSecureTextEntry = true
        tf.borderStyle = UITextField.BorderStyle.none
        tf.textColor = UIColor.pinkColor
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.addPadding(.left(4))
        tf.tintColor = UIColor.pinkColor
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let signUpButton: UIButton = {
        let b = UIButton()
        b.setTitle("CONTINUE", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        b.backgroundColor = UIColor.pinkColor
        b.layer.cornerRadius = 25
        return b
    }()
    
    lazy var tapGesture:UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        return tg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        signUpButton.isEnabled = false
        
        emailTextfield.delegate = self
        usernameTextfield.delegate = self
        nameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        setupViews()
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.yellowColor
        self.view.addSubview(emailLabel)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(usernameTextfield)
        self.view.addSubview(nameTextfield)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(signUpButton)
        
        topConstraint = emailLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -210)
        
        NSLayoutConstraint.activate([
            topConstraint,
            emailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            emailLabel.widthAnchor.constraint(equalToConstant: 250),
            emailLabel.heightAnchor.constraint(equalToConstant: 30),
            
            emailTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            emailTextfield.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 4),
            emailTextfield.heightAnchor.constraint(equalToConstant: 40),
            emailTextfield.widthAnchor.constraint(equalToConstant: 250),
            
            usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            usernameLabel.topAnchor.constraint(equalTo: self.emailTextfield.bottomAnchor, constant: 8),
            usernameLabel.widthAnchor.constraint(equalToConstant: 250),
            usernameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            usernameTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            usernameTextfield.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 4),
            usernameTextfield.heightAnchor.constraint(equalToConstant: 40),
            usernameTextfield.widthAnchor.constraint(equalToConstant: 250),
            
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            nameLabel.topAnchor.constraint(equalTo: self.usernameTextfield.bottomAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            
            nameTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            nameTextfield.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 4),
            nameTextfield.heightAnchor.constraint(equalToConstant: 40),
            nameTextfield.widthAnchor.constraint(equalToConstant: 250),
            
            passwordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            passwordLabel.topAnchor.constraint(equalTo: self.nameTextfield.bottomAnchor, constant: 8),
            passwordLabel.widthAnchor.constraint(equalToConstant: 250),
            passwordLabel.heightAnchor.constraint(equalToConstant: 30),
            
            passwordTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            passwordTextfield.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 4),
            passwordTextfield.widthAnchor.constraint(equalToConstant: 250),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 40),
            
            signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            signUpButton.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 180),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc func signUpTapped(){
        ud.set(emailTextfield.text, forKey: "email")
        ud.set(usernameTextfield.text, forKey: "username")
        ud.set(nameTextfield.text, forKey: "name")
        ud.set(passwordTextfield.text, forKey: "password")
        let recordProfileVideoController = RecordVideoViewController()
        recordProfileVideoController.isTutorialMode = true
        recordProfileVideoController.mode = .signupMode
        navigationController?.pushViewController(recordProfileVideoController, animated: true)
    }
    
    @objc func screenTapped(){
        view.endEditing(true)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextfield.text?.isEmpty == false && usernameTextfield.text?.isEmpty == false && nameTextfield.text?.isEmpty == false && passwordTextfield.text?.isEmpty == false
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.blueColor
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.pinkColor
        }
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        topConstraint.constant = -310
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardHide(notification: Notification) {
        topConstraint.constant = -210
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
