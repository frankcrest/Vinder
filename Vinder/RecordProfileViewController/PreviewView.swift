//
//  PreviewView.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/27/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
    override class var layerClass : AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer{
        return layer as! AVCaptureVideoPreviewLayer
    }

}
