//
//  SelfAnnotationView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-03.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

class SelfAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            image = UIImage(named: "aim")!.scaleImage(toSize: CGSize.init(width: 10, height: 10))
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           options: [.autoreverse, .repeat, .allowUserInteraction],
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
                           completion: nil
                
            )

        }
    }
    
}
