//
//  NearbyUser.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/19/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

enum UserGender{
    case male
    case female
}

class NearbyUser: NSObject , MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var username : String!
    var imageName : String!
    var gender : UserGender!
    var profileURL: String?
    
    
    
    init(username : String, imageName: String, coordinate: CLLocationCoordinate2D, gender : UserGender){
        self.username = username
        self.imageName = imageName
        self.coordinate = coordinate
        self.gender = gender
    }
    
    var subtitle: String? {
        return username
    }
}
