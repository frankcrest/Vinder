//
//  MessageVideoPlayerViewController.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-26.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class MessageVideoPlayerViewController: UIViewController, UpdateProgressDelegate {
    
    private let videoPlayerView:UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var url: String!
    private let loadingView = LoadingView()
    private let videoPlayer = VideoPlayer()
    private let ws = WebService()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ws.updateProgressDelegate = self
        
        view.addSubview(videoPlayerView)
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            videoPlayerView.widthAnchor.constraint(equalTo:view.widthAnchor),
            videoPlayerView.heightAnchor.constraint(equalTo:view.heightAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        
        
        videoPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissmissPlayer)))
        guard let videoURL = URL(string: url) else { return }
        ws.downloadMSGVideo(at: videoURL) { (url, error) in
            guard error == nil else { return }
            guard let url = url else { return }
            
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.videoPlayer.playVideo(atUrl: url, on: self.videoPlayerView)
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let task = ws.msgDLTSK {
            task.cancel()
        }
        videoPlayer.player?.pause()
        videoPlayer.player = nil
    }
    
    func updateProgress(progress: Double) {
        self.loadingView.progressLabel.text = "Downloading: \(round(progress))%"
    }
    
    @objc func dissmissPlayer() {

        navigationController?.popViewController(animated: true)
    }
    
    
}
