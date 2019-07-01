
//  RecordVideoViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia

enum Mode {
  case signupMode
  case messageMode
  case profileMode
}


class RecordVideoViewController: UIViewController, UpdateProgressDelegate {
  
  
  //MARK: UI VIEW PROPERTIES
  let centerView = UIView()
  let topView = UIView()
  let bottomView = UIView()
  var loading: LoadingView!
  let buttonView = ButtonView()
  let notSurebutton : UIButton = {
    let b = UIButton()
    b.translatesAutoresizingMaskIntoConstraints = false
    b.setImage(UIImage(named:"information"), for: .normal)
    b.addTarget(self, action: #selector(bringBackTutorial), for: .touchUpInside)
    return b
  }()
  let tutorialView = TutorialView()
  let recordPreviewView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    //TODO: NEED TO CHANGE BACKGROUND
    view.backgroundColor = .black
    return view
  }()
  
  
  //MARK: PROPERTIES
  
  let webService = WebService()
  let videoReviewer = VideoPlayer()
  let cameraController = CameraController()
  var isTutorialMode = false
  var mode: Mode!
  var toUserID: String?
  
  //MARK: ViewWDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCameraController()
    
    cameraController.startAnimationDelegate = self
    buttonView.recordButtonView.videoHandlerDelegate = self
    webService.updateProgressDelegate = self
    
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
    
    if mode == Mode.profileMode || mode == Mode.signupMode {
      setupMaskView()
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
      
      notSurebutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      notSurebutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      notSurebutton.heightAnchor.constraint(equalToConstant: 50),
      notSurebutton.widthAnchor.constraint(equalToConstant: 50),
      
      ])
  }
  
  
  func setupMaskView() {
    
    centerView.translatesAutoresizingMaskIntoConstraints = false
    centerView.backgroundColor = .clear
    view.addSubview(centerView)
    
    topView.translatesAutoresizingMaskIntoConstraints = false
    topView.backgroundColor = .black
    view.insertSubview(topView, aboveSubview: recordPreviewView)
    
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    bottomView.backgroundColor = .black
    view.insertSubview(bottomView, aboveSubview: recordPreviewView)
    
    NSLayoutConstraint.activate([
      
      centerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      centerView.heightAnchor.constraint(equalTo: view.widthAnchor),
      centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      topView.topAnchor.constraint(equalTo: view.topAnchor),
      topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topView.bottomAnchor.constraint(equalTo: centerView.topAnchor),
      
      bottomView.topAnchor.constraint(equalTo: centerView.bottomAnchor),
      bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      
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
    
    if sender.titleLabel?.text == "Switch"{
      do {
        try cameraController.switchCameras()
      } catch {
        print("can not swict camera: \(error)")
      }
    }
    
    //MARK: CONFIRM BUTTON
    
    if sender.titleLabel?.text == "Confirm" || sender.titleLabel?.text == "Send"{
      
      presentLoadingView()
      
      switch mode! {
      case .signupMode:
        registerMode()
      case .messageMode:
        messageMode()
      case .profileMode:
        profileMode()
      }
    }
  }
  
  func updateProgress(progress: Double) {
    loading.progressLabel.text = "Uploading: \(round(progress))%"
  }
  
  @objc func backButton(_ sender: UIButton) {
    
    if sender.titleLabel?.text == "Back" {
      self.dismiss(animated: true, completion: nil)
      navigationController?.popViewController(animated: true)
    }
    
    if sender.titleLabel?.text == "Retake" {
      if isTutorialMode {
        notSurebutton.isHidden = false
      }
      
      buttonView.switchCameraButton.setTitle("Switch", for: .normal)
      sender.setTitle("Back", for: .normal)
      clearVideoReviewLayer()
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
  
  //MARK: HELPER
  func clearVideoReviewLayer() {
    videoReviewer.player?.pause()
    videoReviewer.player = nil
    self.videoReviewer.playerLayer?.removeFromSuperlayer()
  }
  
  
}

//MARK: START/ STOP RECORDING

extension RecordVideoViewController: VideoHandlerDelegate, StartAnimationDelegate {
  
  func startRecording() {
    cameraController.startRecording(toURL:cameraController.fileURL)
  }
  
  func stopRecording(){
    
    buttonView.recordButtonView.hideCircleBar()
    
    cameraController.stopRecording()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      
      self.cameraController.removePreview()
      self.videoReviewer.playVideo(atUrl: self.cameraController.fileURL, on: self.recordPreviewView )
      
      self.buttonView.backButton.setTitle("Retake", for: .normal)
      
      switch self.mode! {
      case .messageMode:
        self.buttonView.switchCameraButton.setTitle("Send", for: .normal)
      default:
        self.buttonView.switchCameraButton.setTitle("Confirm", for: .normal)
      }
      
      self.notSurebutton.isHidden = true
    }
  }
  
  func startAnimation() {
    buttonView.recordButtonView.startAnimation()
  }
  
}

//MARK: MODES

extension RecordVideoViewController {
  
  
  func registerMode() {
    
    cropVideo(videoURL: cameraController.fileURL) { (croppedURL) -> (Void) in
      self.captureRandomFrame(profileURL: croppedURL) { (profileImageURL) in
        self.webService.uploadVideo(atURL: croppedURL) { (url) -> (Void) in
          self.webService.register(withProfileURL: url, profileImageURL: profileImageURL) { (succeeded, error) in
            
            if succeeded {
              
              self.loading.removeFromSuperview()
              self.clearVideoReviewLayer()
              self.dismiss(animated: true, completion: nil)
              
            } else {
              print("error:\(String(describing: error))")
            }
          }
        }
      }
    }
    
    
  }
  
  
  func messageMode() {
    
    guard let userID = self.toUserID else { return }
    
    self.captureFirstFrame(profileURL: cameraController.fileURL) { (imageURL) in
      
      self.webService.uploadVideo(atURL: self.cameraController.fileURL) { (videoURL) -> (Void) in
        
        self.webService.sendMessage("\(videoURL)", imageURL: imageURL, to: userID) { (err) in
          guard err == nil else {
            print("cant send message : \(String(describing: err))")
            return
          }
          let mapVC = self.navigationController?.viewControllers[0] as! MapViewController
          mapVC.profileview.isHidden = true
          self.clearVideoReviewLayer()
          self.navigationController?.popViewController(animated: true)
          
        }
      }
    }
  }
    
    func profileMode() {

        cropVideo(videoURL: cameraController.fileURL, completion: {(croppedURL) -> (Void) in
                
                self.webService.uploadVideo(atURL: croppedURL) { (url) -> (Void) in
                    
                    self.webService.changeProfile("\(url)") { (err) in
                        guard err == nil else {
                            print("cant change video profile: \(String(describing: err))")
                            return
                        }
                        self.clearVideoReviewLayer()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            
        })
      
      
    }
    
    
}



//MARK: Video helper methods
extension RecordVideoViewController {
  
  func captureFirstFrame(profileURL : URL,completion: @escaping (String) -> Void ){
    let avAsset = AVURLAsset(url: profileURL, options: nil)
    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
    imageGenerator.appliesPreferredTrackTransform = true
    var thumbnail: UIImage?
    
    
    do{
      thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: 1), actualTime: nil))
    } catch let error  {
      print(error)
      print("No image")
    }
    
    let imageData = thumbnail!.jpegData(compressionQuality: 1.0)
    
    webService.uploadImage(withData: imageData!, completion: { (url) in
      completion("\(url)")
    })
    
  }
  
  
  func captureRandomFrame(profileURL : URL,completion: @escaping (String) -> Void ){
    let avAsset = AVURLAsset(url: profileURL, options: nil)
    let duration = avAsset.duration
    let durationTime = CMTimeGetSeconds(duration)
    let imageGenerator = AVAssetImageGenerator(asset: avAsset)
    imageGenerator.appliesPreferredTrackTransform = true
    var thumbnail: UIImage?
    
    print("\(durationTime)")
    
    let captureTime = Double.random(in: 0 ... Double(durationTime))
    
    do{
      thumbnail = try UIImage(cgImage: imageGenerator.copyCGImage(at: CMTime(seconds: captureTime, preferredTimescale: 1), actualTime: nil))
    } catch let error {
      print(error)
      print("No image")
    }
    
    let imageData = thumbnail!.jpegData(compressionQuality: 1.0)
    
    webService.uploadImage(withData: imageData!, completion: { (url) in
      completion("\(url)")
    })
    
  }
  
  func cropVideo(videoURL : URL, completion : @escaping (_ outputURL : URL) -> (Void) ){
    let videoAsset : AVAsset = AVAsset(url: videoURL)
    let duration = videoAsset.duration
    let durationTime = CMTimeGetSeconds(duration)
    let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first! as AVAssetTrack
    //        let clipAudioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first! as AVAssetTrack
    
    let videoComposition = AVMutableVideoComposition(propertiesOf: videoAsset)
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let fileURL = paths[0].appendingPathComponent("croppedvideo.mov")
    do { try FileManager.default.removeItem(at: fileURL) } catch {}
    print("PAth \(paths[0])")
    
    print("cropped: \(durationTime)")
    
    videoComposition.renderSize = CGSize(width: 1080, height: 1080)
    videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 60)
    
    let transformer = AVMutableVideoCompositionLayerInstruction( assetTrack: clipVideoTrack )
    let transform1 = CGAffineTransform( translationX: clipVideoTrack.naturalSize.height, y: -( clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height ) / 2 )
    let transform2 = transform1.rotated(by: CGFloat( Double.pi / 2 ) )
    transformer.setTransform( transform2, at: CMTime.zero)
    
    
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.enablePostProcessing = true
    //        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(durationTime, preferredTimescale: 1200000))
    instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
    
    instruction.layerInstructions = [transformer]
    videoComposition.instructions = [instruction]
    
    let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
    exporter.videoComposition = videoComposition
    exporter.outputURL = fileURL
    exporter.outputFileType = AVFileType.mov
    
    exporter.exportAsynchronously( completionHandler: { () -> Void in
      
      DispatchQueue.main.async(execute: {
        completion( fileURL )
        print("DONE \(exporter.error?.localizedDescription ?? "okay")")
      })
      
    })
  }
}
