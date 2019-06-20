//
//  RecordVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RecordVideoViewController: UIViewController {

  var ref = Database.database().reference()
  
  let ud = UserDefaults.standard
  
  let recordView:UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = .blue
    return v
  }()
  
  let recordButton:UIButton = {
    let button = UIButton()
    button.setTitle("record", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let cancleButton:UIButton = {
    let button = UIButton()
    button.setTitle("cancle", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(cancleTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let retakeVideoButton: UIButton = {
    let button = UIButton()
    button.setTitle("retake", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("confirm", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  func setupViews(){
    self.view.addSubview(recordView)
    self.view.addSubview(recordButton)
    self.view.addSubview(cancleButton)
    self.view.addSubview(retakeVideoButton)
    self.view.addSubview(confirmButton)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.isHidden = true
    
    NSLayoutConstraint.activate([
      recordView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      recordView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      recordView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      recordView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      
      recordButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
      recordButton.heightAnchor.constraint(equalToConstant: 50),
      recordButton.widthAnchor.constraint(equalToConstant: 50),
      
      cancleButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      cancleButton.trailingAnchor.constraint(equalTo: self.recordButton.leadingAnchor, constant: -30),
      cancleButton.heightAnchor.constraint(equalToConstant: 50),
      cancleButton.widthAnchor.constraint(equalToConstant: 50),
      
      confirmButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100),
      confirmButton.heightAnchor.constraint(equalToConstant: 50),
      confirmButton.widthAnchor.constraint(equalToConstant: 50),
      
      retakeVideoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
      retakeVideoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100),
      retakeVideoButton.heightAnchor.constraint(equalToConstant: 50),
      retakeVideoButton.widthAnchor.constraint(equalToConstant: 50),
      ])
  }
  
  @objc func recordTapped(){
    print("recording")
  }
  
  @objc func cancleTapped(){
    print("cancle")
  }
  
  @objc func retakeButtonTapped(){
    print("retake")
  }
  
  @objc func confirmTapped(){
    guard let email = ud.string(forKey: "email") else {return}
    guard let password = ud.string(forKey: "password") else {return}
    guard let name = ud.string(forKey: "name") else {return}
    guard let username = ud.string(forKey: "username") else {return}
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if let error = error{
        print(error)
        return
      }
      guard let uid = user?.user.uid else {return}
      self.ref.child("users").child(uid).setValue((["email":email, "username":username, "name":name]), withCompletionBlock: { (error, ref) in
        if let error = error{
          print(error)
          return
        }
        let mapViewVC = MapViewController()
        self.present(mapViewVC, animated: true, completion: nil)
      })
    }
  }
  
}
