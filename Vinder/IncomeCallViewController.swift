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
    var callerId :String?
  
    lazy var videoView : VideoView = {
        let v = VideoView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.isHidden = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
//        videoView.configureView(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    }
  
    func setUpViews(){
        self.view.addSubview(videoView)
        
        videoView.leftButton.setImage(UIImage(named: "hangup"), for: .normal)
        videoView.rightButton.setImage(UIImage(named: "call"), for: .normal)
        videoView.leftButton.backgroundColor = .red
        
        videoView.leftButton.addTarget(self, action: #selector(rejectCallTapped), for: .touchUpInside)
        videoView.rightButton.addTarget(self, action: #selector(pickUpCallTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
