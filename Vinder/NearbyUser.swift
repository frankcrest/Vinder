//
//  NearbyUser.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/19/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

class NearbyUser: NSObject , MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var username : String!
    var imageName : String!
    
    
    init(username : String, imageName: String, coordinate: CLLocationCoordinate2D){
        self.username = username
        self.imageName = imageName
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return username
    }
}
