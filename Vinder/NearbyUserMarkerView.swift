//
//  NearbyUserMarkerView.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/19/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

class NearbyUserMarkerView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let nearbyUser = newValue as? NearbyUser else {return}
            canShowCallout = false
            calloutOffset = CGPoint(x:5, y:-5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = nearbyUser.imageName{
                glyphImage = UIImage(named: imageName)
            } else{
                glyphImage = nil
            }
        }
    }

}
