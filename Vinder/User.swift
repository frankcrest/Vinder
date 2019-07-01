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

class User: NSObject ,MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D {
        get{
            return CLLocationCoordinate2D(latitude: Double(lat)! as CLLocationDegrees, longitude: Double(lon)! as CLLocationDegrees)
        }
    }
    var uid:String
    var token:String
    var username:String
    var name:String
    var email: String
    var profileImageUrl:String
    var gender: UserGender
    var lat:String
    var lon:String
    var profileVideoUrl:String
    var onlineStatus: Bool?
    
    init(uid : String, token:String,  username: String, name: String, email: String, profileImageUrl : String, gender:UserGender, lat:String, lon:String, profileVideoUrl:String, onlineStatus: Bool?){
        self.uid = uid
        self.token = token
        self.username = username
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.gender = gender
        self.lat = lat
        self.lon = lon
        self.profileVideoUrl = profileVideoUrl
        self.onlineStatus = onlineStatus
    }
    
    var subtitle: String? {
        return username
    }
}
