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
    var image : String!
    
    init(username : String, image: String, coordinate: CLLocationCoordinate2D){
        self.username = username
        self.image = image
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return username
    }
}
