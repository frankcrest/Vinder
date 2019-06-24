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
    
    let videoView : VideoView = {
        let v = VideoView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.setUpViews(callType: .IncomeCall)
        videoView.configure(url: callingUser.profileVideoUrl)
        videoView.play()
    }
    
    func setUpViews(){
        self.view.addSubview(videoView)
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ,constant: -20),
            videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
            ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    

}
