//
//  NearbyUserView.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/19/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

class NearbyUserView: MKAnnotationView {
    
    var userID: String?
    override var annotation : MKAnnotation? {
        willSet{
            guard let user = newValue as? User else {return}
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            self.userID = user.uid
            self.loadProfileImage(withID: user.uid)

        }
    }
    
    func loadProfileImage(withID id: String) {
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: id as NSString) {

            image = imageFromCache.scaleImage(toSize: CGSize.init(width: 25, height: 25))
            return
        }
        
        WebService().fetchProfile(ofUser: id) { (userInfo) in
            DispatchQueue.main.async {
                guard let url =  URL(string: userInfo["profileImageUrl"]!) else { return }
                do {
                    let image = try UIImage(data: Data(contentsOf: url))
                    guard let imageToCache = image else { return }
                    if self.userID == id {
                        self.image = imageToCache.scaleImage(toSize: CGSize.init(width: 25, height: 25))
                    }
                    imageCache.setObject(imageToCache, forKey: id as NSString)
                }catch let error {
                    print(error)
                }
            }
        }
    }
}
    



//MARK: UIImage Helper method
extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
