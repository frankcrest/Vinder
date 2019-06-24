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

class User: NSObject , MKAnnotation{
  
  var coordinate: CLLocationCoordinate2D {
    get{
      return CLLocationCoordinate2D(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(lon) as! CLLocationDegrees)
    }
  }
  var uid:String
  var username:String
  var name:String
  var imageUrl:String?
  var gender: UserGender
  var lat:String
  var lon:String
  
  init(uid : String, username: String, name: String, imageUrl : String, gender:UserGender, lat:String, lon:String){
    self.uid = uid
    self.username = username
    self.name = name
    self.imageUrl = imageUrl
    self.gender = gender
    self.lat = lat
    self.lon = lon
  }
  
  var subtitle: String? {
    return username
  }
}