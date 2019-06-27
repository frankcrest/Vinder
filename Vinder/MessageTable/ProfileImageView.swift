//
//  ProfileImageView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-27.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    var imageUrlString: String?
    
    func loadThumbnailImage(withURL imageURL: String) {
        
        imageUrlString = imageURL
        guard let url = URL(string: imageURL) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageURL as NSString) {
            self.image = imageFromCache
            return
        }
        
        WebService().fetchThumbnailImage(with: url) { (url, error) in
            
            guard error == nil else { return }
            guard let url = url else { return }
            
            DispatchQueue.main.async {
                do {
                    let image = try UIImage(data: Data(contentsOf: url))
                    guard let imageToCache = image else { return }
                    if self.imageUrlString == imageURL {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: imageURL as NSString)
                }catch let error {
                    print(error)
                }
                
            }
        }
    }

}
