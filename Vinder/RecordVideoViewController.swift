
//  RecordVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit



class RecordVideoViewController: UIViewController, UpdateProgressDelegate {
    
    
    //MARK: UI VIEW PROPERTIES
    var loading: LoadingView!
    let buttonView = ButtonView()
    let notSurebutton = UIButton()
    let tutorialView = TutorialView()
    let recordPreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //TODO: NEED TO CHANGE BACKGROUND
        view.backgroundColor = .black
        return view
    }()
    
    
    //MARK: PROPERTIES
    
    let register = WebService()
    let videoReviewer = VideoPlayer()
    let cameraController = CameraController()
    var isTutorialMode = false
    
    //MARK: ViewWDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCameraController()
        
        cameraController.startAnimationDelegate = self
        buttonView.recordButtonView.videoHandlerDelegate = self
        register.updateProgressDelegate = self
        
        hideNavBar()
        notSurebutton.isHidden = true
        setupViews()
        if isTutorialMode {
            self.setupTutorialView()
            self.recordPreviewView.isHidden = true
            self.buttonView.isHidden = true
            self.notSurebutton.isHidden = false
            //self.videoReviewer.playVideo(atUrl:url, on: self.tutorialView)
            
            
        }
        
    }
    
    
    //MARK: CAMERA CONTROLLER
    
    func configureCameraController() {
        cameraController.prepare { (error) in
            if let error = error {
                print("can not configure camera controller: \(error)")
            }
            try? self.cameraController.displayPreview(on: self.recordPreviewView)
        }
    }
    
    
    //MARK: SETUP VIEWS
    
    func setupViews(){
        
        view.addSubview(recordPreviewView)
        view.addSubview(buttonView)
        view.addSubview(notSurebutton)
        
        notSurebutton.translatesAutoresizingMaskIntoConstraints = false
        notSurebutton.setTitle("NOT SURE WHAT TO DO?", for: .normal)
        notSurebutton.addTarget(self, action: #selector(bringBackTutorial), for: .touchUpInside)
        
        buttonView.switchCameraButton.addTarget(self, action: #selector(switchCameraOrConfirm(_:)), for: .touchUpInside)
        buttonView.backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 1/12),
            buttonView.widthAnchor.constraint(equalToConstant: view.frame.width),
            buttonView.heightAnchor.constraint(equalToConstant: view.frame.height * 1/12),
            
            recordPreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            recordPreviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            recordPreviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            recordPreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
            notSurebutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            notSurebutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            ])
    }
    
    func setupTutorialView() {
        
        view.addSubview(tutorialView)
        tutorialView.gotItButton.addTarget(self, action: #selector(gotItTapped), for: .touchUpInside)
        tutorialView.replayButton.addTarget(self, action: #selector(replayTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            tutorialView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tutorialView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tutorialView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tutorialView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        videoReviewer.playVideo(atUrl: cameraController.tutorialURL, on: tutorialView)
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func presentLoadingView() {
        
        loading = LoadingView()
        self.view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.widthAnchor.constraint(equalTo: view.widthAnchor),
            loading.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            ])
    }
    
    
    //MARK: ACTIONS
    
    @objc func bringBackTutorial() {
        recordPreviewView.isHidden = true
        buttonView.isHidden = true
        setupTutorialView()
        
    }
    
    @objc func switchCameraOrConfirm(_ sender: UIButton){
        
        if sender.titleLabel?.text == "switch"{
            do {
                try cameraController.switchCameras()
            } catch {
                print("can not swict camera: \(error)")
            }
        }
        
        //MARK: CONFIRM Button
        
        if sender.titleLabel?.text == "confirm" {
            
            presentLoadingView()
            
            register.uploadVideo(atURL: cameraController.fileURL) { (url) -> (Void) in
                
                self.register.register(withProfileURL: url) { (succeeded, error) in
                    
                    if succeeded {
                        let mapViewVC = MapViewController()
                        self.loading.removeFromSuperview()
                        self.present(mapViewVC, animated: true, completion: nil)
                        
                    } else {
                        print("error:\(String(describing: error))")
                    }
                }
            }
        }
    }
    
    func updateProgress(progress: Double) {
        loading.progressLabel.text = "Uploading: \(round(progress))%"
    }
    
    
    @objc func backButton(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "back" {
            self.navigationController?.popViewController(animated: true)
        }
        
        if sender.titleLabel?.text == "retake" {
            notSurebutton.isHidden = false
            buttonView.switchCameraButton.setTitle("switch", for: .normal)
            sender.setTitle("back", for: .normal)
            videoReviewer.player?.pause()
            videoReviewer.player = nil
            self.videoReviewer.playerLayer?.removeFromSuperlayer()
            self.configureCameraController()
            buttonView.switchCameraButton.isHidden = false
            buttonView.recordButtonView.showCircleBar()
        }
    }
    
    
    @objc func gotItTapped() {
        tutorialView.removeFromSuperview()
        recordPreviewView.isHidden = false
        buttonView.isHidden = false
    }
    
    @objc func replayTapped() {
        
    }
    
}

//MARK: START/ STOP RECORDING

extension RecordVideoViewController: VideoHandlerDelegate, StartAnimationDelegate {
    
    func startRecording() {
        cameraController.startRecording()
    }
    
    func stopRecording(){
        
        buttonView.recordButtonView.hideCircleBar()
        
        cameraController.stopRecording()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.cameraController.removePreview()
            self.videoReviewer.playVideo(atUrl: self.cameraController.fileURL, on: self.recordPreviewView )
            
            self.buttonView.backButton.setTitle("retake", for: .normal)
            self.buttonView.switchCameraButton.setTitle("confirm", for: .normal)
            self.notSurebutton.isHidden = true
        }
    }
    
    func startAnimation() {
        buttonView.recordButtonView.startAnimation()
    }
    
}


