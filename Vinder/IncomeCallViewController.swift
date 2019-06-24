//
//  IncomeCallViewController.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/24/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class IncomeCallViewController: UIViewController {
    
    var callingUser : User!
    
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
        videoView.configure(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    }
    
    func setUpViews(){
        self.view.addSubview(videoView)
        
        videoView.leftButton.setImage(UIImage(named: "reject"), for: .normal)
        videoView.rightButton.setImage(UIImage(named: "call"), for: .normal)
        
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
        print("pick up")
        
    }
    
    @objc func rejectCallTapped(){
      videoView.pause()
      self.dismiss(animated: true, completion: nil)
        print("reject call")
        
    }

}
