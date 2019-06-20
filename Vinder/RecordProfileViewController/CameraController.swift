//
//  CameraController.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraController: NSObject, AVCaptureFileOutputRecordingDelegate {

    //MARK: PROPERTIES
    
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var audioInput: AVCaptureDevice?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var fileURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = paths[0].appendingPathComponent("profile.mov")
        try? FileManager.default.removeItem(at: fileURL)
        return fileURL
    }()
    
    
    //MARK: DISPLAY PREVIEW LAYER
    func displayPreview(on view: UIView) throws {
        
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func removePreview() {
        self.previewLayer?.removeFromSuperlayer()
    }
    
    //MARK: SWITCH CAMERA
    
    func switchCameras() throws {
        
        guard  let currentCameraPosition = currentCameraPosition, let captureSession = captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        func switchToFront() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput), let frontCamera = self.frontCamera else {
                throw CameraControllerError.invalidOperation
            }
            
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
                self.currentCameraPosition = .front
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchToRear() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput), let rearCamera = self.rearCamera else {
                throw CameraControllerError.invalidOperation
            }
            
            rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(rearCameraInput!) {
                captureSession.addInput(rearCameraInput!)
                self.currentCameraPosition = .rear
            } else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRear()
        case .rear:
            try switchToFront()
        }
        
        captureSession.commitConfiguration()
    }
    
    //MARK: RECORD AND SAVE VIDEO
    
    func startRecording() {
        
        videoOutput?.startRecording(to: fileURL, recordingDelegate: self)
    
    }
    
    func stopRecording() {
        videoOutput?.stopRecording()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // show progress bar ... 
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            print("can not save: \(String(describing: error))")
            return
        }
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        
        
    }
    
    
    
}



//MARK: PREPARE

extension CameraController {
    
    func prepare(completion: @escaping (Error?) -> Void) {
        
        //handle the creation and config of new capture seesion
        
        //START
        
        //MARK: 1. create a capture session
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        //MARK:2.obtain and config capture devices
        func configureCaptureDevices() throws {
            //get video devices
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
            let cameras = (session.devices.compactMap( { $0} ))
            guard !cameras.isEmpty else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                if camera.position == .back {
                    self.rearCamera = camera
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
            
            // get audio device
            audioInput = AVCaptureDevice.default(for: AVMediaType.audio)
        }
        
        //MARK: 3.create input devices
        func configureDeviceInputs() throws {
            
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            try captureSession.addInput(AVCaptureDeviceInput(device: audioInput!))
            
            
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                }
                
                self.currentCameraPosition = .front
            }
                
            else if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                }
                self.currentCameraPosition = .rear
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
            
        }
        //MARK: 4.config video output
        func configurePhotoOutput() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            captureSession.sessionPreset = AVCaptureSession.Preset.high
            
            videoOutput = AVCaptureMovieFileOutput()
            
            
            
            if captureSession.canAddOutput(self.videoOutput!) {
                captureSession.addOutput(self.videoOutput!)
            }
            
            captureSession.commitConfiguration()
            
            captureSession.startRunning()
        }
        
        
        // END
        DispatchQueue(label: "prepare").sync {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }
        
    }
}

//MARK: ENUMS

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    enum CameraPosition{
        case front
        case rear
    }
}

