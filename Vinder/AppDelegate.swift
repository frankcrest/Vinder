//
//  AppDelegate.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  
  var window: UIWindow?
  let ud = UserDefaults.standard
  var ref : DatabaseReference?
  let notificationCenter = NotificationCenter.default
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    ref = Database.database().reference()
    
    WebService().checkAuth { (err) in
      print("auth error \(String(describing: err))")
        if err != nil {
            print("auth err \(String(describing: err))")
            do{
                try WebService().logOut()
            }catch let err{
                print("can not log out \(err)")
            }
        }
    }
    
    
    // Override point for customization after application launch.
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
      // For iOS 10 data message (sent via FCM
      Messaging.messaging().delegate = self
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound,], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    self.window = UIWindow(frame:UIScreen.main.bounds)
    self.window!.tintColor = UIColor.white
    let initialController = MapViewController()
    let nav = UINavigationController()
    nav.viewControllers = [initialController]
    window?.rootViewController = nav
    
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("received silent notification \(userInfo)")
    
    guard let uid = userInfo["event_id"] as? String else {return}
    guard let title = userInfo["title"] as? String else {return}
    guard let body = userInfo["body"] as? String else {return}
    let ref = Database.database().reference()
    
    if body == "Accepted" {
      print("remove callAccepted from firebase")
      ref.child("callAccepted").child(uid).removeValue()
    }else if body == "Rejected"{
      print("remove callRejected from firebase")
      ref.child("callRejected").child(uid).removeValue()
    }else if body == "HangUp"{
      print("remove Hangup from firebase")
      ref.child("hangup").child(uid).removeValue()
    }
    
    let callResponse = CallResponse(uid: uid, title: title, body: body)
    notificationCenter.post(name: NSNotification.Name.CallResponseNotification, object: callResponse)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {

  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {

    guard let userID = Auth.auth().currentUser?.uid else { return }
    WebService().goOffline(userID)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {

    guard let userID = Auth.auth().currentUser?.uid else { return }
    WebService().goOnline(userID)
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {

  }
  
  func applicationWillTerminate(_ application: UIApplication) {

    guard let userID = Auth.auth().currentUser?.uid else { return }
    WebService().goOffline(userID)
  }
  
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    completionHandler()
    
    let userInfo = response.notification.request.content.userInfo
    let callerId = userInfo["callerId"] as? String
    guard let firebaseRef = ref else {return}
    if callerId != nil {
      firebaseRef.child("calling").child(callerId!).removeValue()
      let presentVC = self.window!.rootViewController!
      let incomeCallVC = IncomeCallViewController()
      incomeCallVC.callerId = callerId!
      presentVC.present(incomeCallVC, animated: true, completion: nil)
    } else{
      print("Do nothing")
    }
  }
  
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    ud.set(fcmToken, forKey: "fcmToken")
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
  // [START ios_10_data_message]
  // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
  // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Received data message: \(remoteMessage.appData)")
  }
  // [END ios_10_data_message]
  
}
