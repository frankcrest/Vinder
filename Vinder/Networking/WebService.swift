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

protocol UpdateProgressDelegate: AnyObject {
  func updateProgress(progress: Double)
}

class WebService {

    
    //MARK: PROPERTIES
    
    var updateProgressDelegate: UpdateProgressDelegate?
    
    var msgDLTSK: StorageDownloadTask?
    
    private var downloadURL: URL!
    private let ref = Database.database().reference()
    private let ud = UserDefaults.standard
    private let storage = Storage.storage()
    let currentUserID = Auth.auth().currentUser?.uid
    
    private var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://vinder-2a778.appspot.com")
  }

  private var profileVideosStorageRef: StorageReference {
    return storageRef.child("profileVideos")
  }
      
      private var profileImageStorageRef: StorageReference {
        return storageRef.child("profileImage")
      }
  
  //download fileURL needs to be changed
  private var fileURL: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let fileURL = paths[0].appendingPathComponent("sample.mov")
    try? FileManager.default.removeItem(at: fileURL)
    return fileURL
  }()
  
  //MARK: AUTH AND UPDATE
  
  func updateUserWithLocation(lat: String, lon: String, uid:String) {
    ref.child("users").child(uid).updateChildValues(["latitude":lat])
    ref.child("users").child(uid).updateChildValues(["longitude":lon])
  }
  
  func logIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      completion(result,error)
    }
  }
  
  func logOut() throws {
    do {
      try Auth.auth().signOut()
      ud.set("", forKey: "uid")
    } catch let err {
      throw err
    }
  }
  
  func sendMessage(_ url: String, imageURL: String, to userID: String,completion: @escaping  (Error?) -> Void)  {
    
    guard let senderID = Auth.auth().currentUser?.uid else { return }
    guard let name = ud.string(forKey: "name") else {return}
    let messageID = UUID().uuidString
    
    self.ref.child("messages").child(userID).child(messageID).setValue(["senderID": senderID, "messageURL": url, "imageURL":imageURL, "messageID": messageID, "sender": name, "timestamp": ServerValue.timestamp()]) { (err, ref) in
      
      completion(err)
    }
    
  }
  
    func register(withProfileURL url: URL,profileImageURL: String, registered: @escaping (Bool, Error?) -> Void) {
    
    guard let email = ud.string(forKey: "email") else {return}
    guard let password = ud.string(forKey: "password") else {return}
    guard let name = ud.string(forKey: "name") else {return}
    guard let username = ud.string(forKey: "username") else {return}
    guard let token = ud.string(forKey: "fcmToken") else {return}
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      
      guard error == nil else {
        registered(false, error)
        return
      }
      guard let uid = user?.user.uid else { return }
      print("Registered uid \(uid)")
      self.ud.set(uid, forKey:"uid")
        self.ref.child("users").child(uid).setValue((["uid": uid, "token": token, "email":email, "username":username, "name":name, "profileVideo": "\(url)", "profileImageUrl": profileImageURL, "onlineStatus": true]), withCompletionBlock: { (error, ref) in
        
        if let error = error{
          print("can not set ref\(error)")
          return
        }
        registered(true, nil)
      })
    }
  }
  
  
  //MARK: UPLOADING
    
    func goOnline(_ userID: String) {
        ref.child("users").child(userID).child("onlineStatus").setValue(true)
    }
    
    func goOffline(_ userID: String) {
        ref.child("users").child(userID).child("onlineStatus").setValue(false)
    }
  
  func changeProfile(_ url: String, completion: @escaping (Error?) -> Void) {
    guard let userID = currentUserID else {
      return
    }
    ref.child("users").child(userID).child("profileVideo").setValue(url) { (err, ref) in
      completion(err)
    }
  }
  
  func uploadVideo(atURL url: URL,  completion: @escaping (URL) -> (Void)) {
    
    let videoName = "\(NSUUID().uuidString)\(url)"
    let ref = profileVideosStorageRef.child(videoName)
    let metaData = StorageMetadata()
    metaData.contentType = "video/quicktime"
    
    let uploadTask = ref.putFile(from: url, metadata: metaData) { (metaData, error) in
      if error != nil {
        print("cant upload video: \(String(describing: error))")
        return
      } else {
        ref.downloadURL { (url, err) in
          guard let downloadURL = url else {
            return
          }
          print("url: \(downloadURL)")
          completion(downloadURL)
        }
      }
    }
    
    uploadTask.observe(.progress) { (snapshot) in
      let percent = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
      print("uploading: \(percent)")
      DispatchQueue.main.async {
        self.updateProgressDelegate?.updateProgress(progress: percent)
      }
    }
  }
  
  func uploadImage(withData data: Data,  completion: @escaping (URL) -> (Void)) {
    
    let imageName = "profileImage_\(UUID().uuidString)"
    let ref = profileImageStorageRef.child(imageName)
    
    let _ = ref.putData(data, metadata: nil) { (metaData, error) in
      if error != nil {
        print("cant upload image: \(String(describing: error))")
        return
      } else {
        ref.downloadURL { (url, err) in
          guard let downloadURL = url else {
            return
          }
          print("url: \(downloadURL)")
          completion(downloadURL)
        }
      }
    }
  }
  
    //MARK: FIREBASE FECTHING
    
    func fetchProfile(ofUser id: String, completion: @escaping (Dictionary<String,Any>) -> Void) {
        
        var userInfo: [String: Any] = [:]
        
        let profileImageFileUrl: URL = {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileURL = paths[0].appendingPathComponent("profiles/profile_\(id)")
            try? FileManager.default.removeItem(at: fileURL)
            return fileURL
        }()
        
        ref.child("users").child(id).observe(DataEventType.value) { (snapshot) in
                guard let infoObject = snapshot.value as? [String:AnyObject] else{return}
                guard let profileImageUrl = infoObject["profileImageUrl"] as? String else {return}
                guard let name = infoObject["name"] as? String else { return }
                guard let profileVideo = infoObject["profileVideo"] as? String else { return }
                let onlineStatus = infoObject["onlineStatus"] as? Bool
                let httpreference = self.storage.reference(forURL: profileImageUrl)
                let _ = httpreference.write(toFile: profileImageFileUrl) { (url, err) in
                    guard err == nil else { return }
                    guard let url = url else { return }
                    userInfo["name"] = name
                    userInfo["profileVideo"] = profileVideo
                    userInfo["profileImageUrl"] = "\(url)"
                    userInfo["onlineStatus"] = onlineStatus
                    completion(userInfo)
                }
        }
    }
    
    func fetchThumbnailImage(with url: URL, completion: @escaping (URL?, Error?) -> Void) {
        
        let thumbnailImageURL: URL = {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileURL = paths[0].appendingPathComponent("thumbnails/thumnail_\(UUID().uuidString)")
            return fileURL
        }()
        
        let httpReference = storage.reference(forURL: "\(url)")
        let _ = httpReference.write(toFile: thumbnailImageURL) { (url, error) in
            completion(url,error)
        }
        
    }
    
    
   
    func fetchAllMessages(completion: @escaping ([Messages]?) ->(Void)) {
      
      guard let userID = currentUserID else {
        return
      }
      var messages: [Messages] = []
      ref.child("messages").child(userID).observe(DataEventType.value) { (snapshot) in
        for messageID in snapshot.children.allObjects as! [DataSnapshot] {
          guard let message = messageID.value as? [String: AnyObject] else { continue }
          guard let messageURL = message["messageURL"] as? String else { continue }
          guard let senderID = message["senderID"] as? String else { continue }
          guard let msgID = message["messageID"] as? String else {continue}
          guard let sender = message["sender"] as? String else {continue}
          guard let timestamp = message["timestamp"] as? Double else {continue}
          guard let imageURL = message["imageURL"] as? String else { continue }
          let timeInterval = timestamp/1000.0
          let messageDate = Date(timeIntervalSince1970: timeInterval)
          
          let msg = Messages(messageID: msgID, senderID: senderID, messageURL: messageURL, sender: sender, timestamp: messageDate, imageURL: imageURL)
          messages.append(msg)
        }

        completion(messages)
      }
    }
    
  func fetchProfileVideo(of user: User, completion: @escaping (URL?, Error?) -> (Void)) {
    
    let profileFileURL: URL = {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let fileURL = paths[0].appendingPathComponent("userProfile/\(user.uid).mov")
      try? FileManager.default.removeItem(at: fileURL)
      return fileURL
    }()
    
    
    let url = user.profileVideoUrl
    let httpReference = storage.reference(forURL: url)
    let downloadTask = httpReference.write(toFile: profileFileURL) { (url, error) in
      completion(url,error)
    }
    downloadTask.observe(.progress) { (snapshot) in
      let percent = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
      DispatchQueue.main.async {
        self.updateProgressDelegate?.updateProgress(progress: percent)
      }
      print("downloading: \(percent)%")
    }
  }
  
    
    func fetchUsers(completion: @escaping ([User]?) -> Void) {
        
        var users: [User] = []
        ref.child("users").observe(.value) { (snapshot) in
            for user in snapshot.children.allObjects as! [DataSnapshot]{
                guard let userObject = user.value as? [String:AnyObject] else{continue}
                guard let name = userObject["name"] as? String else {continue}
                guard let username = userObject["username"] as? String else{continue}
                guard let uid = userObject["uid"] as? String else {continue}
                guard let lat = userObject["latitude"] as? String else {continue}
                guard let lon = userObject["longitude"] as? String else{continue}
                guard let profileVideo = userObject["profileVideo"] as? String else {continue}
                guard let token = userObject["token"] as? String else {continue}
                guard let profileImageUrl = userObject["profileImageUrl"] as? String else {continue }
                let onlineStatus = userObject["onlineStatus"] as? Bool
                if uid == Auth.auth().currentUser?.uid {
                    self.ud.set(name, forKey: "name")
                }
                let user = User(uid: uid, token:token , username: username, name: name , profileImageUrl: profileImageUrl, gender: .female, lat: lat, lon: lon, profileVideoUrl: profileVideo, onlineStatus: onlineStatus)
                users.append(user)
                print("user \(user.name)")
                print("users.count \(users.count)")
            }
            completion(users)
        }
    }
    
    
    func downloadMSGVideo(at url: URL, completion: @escaping (URL?, Error?) -> Void) {
        
        let msgFileURL: URL = {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileURL = paths[0].appendingPathComponent("msg/\(UUID().uuidString).mov")
            return fileURL
        }()
        
        let httpReference = storage.reference(forURL: "\(url)")
        let downloadTask = httpReference.write(toFile: msgFileURL) { (url, error) in
            completion(url,error)
        }
        msgDLTSK = downloadTask
        downloadTask.observe(.progress) { (snapshot) in
            let percent = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            DispatchQueue.main.async {
                self.updateProgressDelegate?.updateProgress(progress: percent)
            }
        }
    }
    
    func deleteMessage(_ message: Messages, completion: @escaping (Error?) -> Void) {
        guard let msgReceiver = Auth.auth().currentUser?.uid else { return }
        let msgVideoRef = storage.reference(forURL: message.messageURL)
        let msgThumnailRef = storage.reference(forURL: message.imageURL)
        let msgID = message.messageID
        let msgRef = ref.child("messages").child(msgReceiver).child(msgID)
        //Delete msg
        print("deleting message ")
        msgRef.removeValue { (err, ref) in
            completion(err)
            guard err == nil else {return}
            // then delete msg content
            print("delete msg content")
            msgVideoRef.delete { (err) in
                guard err == nil else {return}
                print("delete video")
            }
            msgThumnailRef.delete { (err) in
                guard err == nil else {return}
                print("delete tn")
            }
        }
        
    }
    
  //MARK:  JOKE API
  
  func fetchJokes(completion: @escaping (Data) -> (Void)) {
    
    let url = URL(string: "https://icanhazdadjoke.com/")
    let request = NSMutableURLRequest(url: url!)
    
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("bad response: \(String(describing: response))")
        return
      }
      
      guard httpResponse.statusCode == 200 else {
        print("http reponse: \(httpResponse.statusCode)")
        return
      }
      
      guard err == nil else {
        print("cant fetch jokes error: \(String(describing: err))")
        return
      }
      
      guard let data = data else {
        print("bad data")
        return
      }
      
      completion(data)
      
    }
    
    task.resume()
    
  }
  
}
