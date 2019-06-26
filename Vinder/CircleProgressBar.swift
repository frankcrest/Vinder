//
//  CircleProgressBar.swift
//  
//
//  Created by Dayson Dong on 2019-06-25.
//

import Foundation
import UIKit

class CircleProgressBar {
    
    var circleLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    var radius: CGFloat!
    func setupCircleProgressBar(on view: UIView) {
        
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        radius = view.bounds.height/2.0
        let circularPath = UIBezierPath(arcCenter: center, radius: radius , startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        circleLayer.frame = view.bounds
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 8
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.strokeEnd = 0
        
        trackLayer.frame = view.bounds
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.darkGray.cgColor
        trackLayer.lineWidth = 8
        trackLayer.fillColor = UIColor.clear.cgColor
        
    }
    
}
