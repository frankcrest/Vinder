//
//  IncomeCallViewController.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/24/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import Firebase

class IncomeCallViewController: UIViewController {
    
    var callingUser : User!
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    let ud = UserDefaults.standard
    let ws = WebService()
    var callerId :String? {
        didSet {
            if let id = callerId {
                callerView.userID = id
                }
            }
        }
  
  var username: String? {
    didSet{
      if let name = username{
         callerView.nameLabel.text = name
      }
    }
  }
    
  
    lazy var callerView : CallerVideoView = {
        let v = CallerVideoView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.isHidden = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        setUpViews()
      if username != nil{
        print("got username calling \(username!)")
      }
    }
  
    func setUpViews(){
        self.view.addSubview(callerView)
    
        callerView.declineButton.addTarget(self, action: #selector(rejectCallTapped), for: .touchUpInside)
        callerView.answerButton.addTarget(self, action: #selector(pickUpCallTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            callerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            callerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            callerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
    
    
  @objc func pickUpCallTapped(){
    print("accept tapped")
    guard let user = currentUser else {return}
    guard let callerId = callerId else {return}
    
    ref.child("callAccepted").child(user.uid).setValue([callerId : 1])
    //create video vc and join call
    let videoVC = VideoViewController()
    videoVC.inCall = true
    videoVC.userWeAreCalling = callerId
    let rootVC = UIApplication.shared.delegate!.window!?.rootViewController!
    rootVC!.dismiss(animated: false, completion: {
      rootVC!.present(videoVC, animated: true, completion: nil)
    })
  }
    
    @objc func rejectCallTapped(){
      guard let user = currentUser else {return}
      guard let callerId = callerId else {return}
      ref.child("callRejected").child(user.uid).setValue([callerId : 1])
      self.dismiss(animated: true, completion: nil)
    }

}
