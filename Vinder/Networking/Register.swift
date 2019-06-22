//
//  Register.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-21.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class Register {
    
    var downloadURL: URL!
    var ref = Database.database().reference()
    
    let ud = UserDefaults.standard
    
    private var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://vinder-2a778.appspot.com")
    }
    private var profileVideosStorageRef: StorageReference {
        return storageRef.child("profileVideos")
    }
    
    func uploadVideo(atURL url: URL,  completion: @escaping (URL) -> (Void)) {
        
        let videoName = "\(NSUUID().uuidString)\(url)"
        let ref = profileVideosStorageRef.child(videoName)
        let uploadTask = ref.putFile(from: url, metadata: nil) { (metaData, error) in
            if error != nil {
                print("cant upload video: \(String(describing: error))")
                return
            } else {
                ref.downloadURL { (url, err) in
                    guard let downloadURL = url else {
                        return
                    }
                    completion(downloadURL)
                }
            }
        }
        
        uploadTask.resume()
        
    }
    
    func register(withProfileURL url: URL, registered: @escaping (Bool, Error?) -> Void) {
        
        guard let email = ud.string(forKey: "email") else {return}
        guard let password = ud.string(forKey: "password") else {return}
        guard let name = ud.string(forKey: "name") else {return}
        guard let username = ud.string(forKey: "username") else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else {
                registered(false, error)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            registered(true, nil)
            
            self.ref.child("users").child(uid).setValue((["email":email, "username":username, "name":name, "profileVideo": "\(url)"]), withCompletionBlock: { (error, ref) in
                
                if let error = error{
                    print("can not set ref error \(error)")
                    return
                }
            })
        }
    }
    
    
    
    
    
}
