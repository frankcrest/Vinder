//
//  ProfileImageView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-27.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    var userID: String?
    var userName: String?
    var profileVideoUrl: String?
    
    func loadProfileImage(withID id: String) {
        
        userID = id
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: id as NSString) {
            self.image = imageFromCache
            return
        }
        
        WebService().fetchProfile(ofUser: id) { (userInfo) in
            DispatchQueue.main.async {
                self.userName = userInfo["name"]
                self.profileVideoUrl = userInfo["profileVideo"]
                guard let url =  URL(string: userInfo["profileImageUrl"]!) else { return }
                do {
                    let image = try UIImage(data: Data(contentsOf: url))
                    guard let imageToCache = image else { return }
                    if self.userID == id {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: id as NSString)
                }catch let error {
                    print(error)
                }
            }
        }
    }
    
    

}
