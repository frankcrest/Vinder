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
   
    self.window = UIWindow(frame:UIScreen.main.bounds)
    let initialController = MapViewController()
    let nav = UINavigationController()
    nav.viewControllers = [initialController]
    window?.rootViewController = nav
    
    self.window?.makeKeyAndVisible()

    let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

    if !isLoggedIn {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
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
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
      ud.set(callerId!, forKey: "callerId")
      print("the caller id is: \(callerId!)")
      firebaseRef.child("calling").child(callerId!).removeValue()
      let presentVC = self.window!.rootViewController!
      let incomeCallVC = IncomeCallViewController()
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
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
    print("received silent notification \(userInfo)")
    
    guard let uid = userInfo["event_id"] as? String else {return}
    guard let title = userInfo["title"] as? String else {return}
    guard let body = userInfo["body"] as? String else {return}
    guard let firebaseRef = ref else {return}
    
    if body == "Accepted" {
      print("remove callAccepted from firebase")
      firebaseRef.child("callAccepted").child(uid).removeValue()
    }else if body == "Rejected"{
      print("remove callRejected from firebase")
      firebaseRef.child("callRejected").child(uid).removeValue()
    }
    
    let callResponse = CallResponse(uid: uid, title: title, body: body)
    notificationCenter.post(name: NSNotification.Name.CallResponseNotification, object: callResponse)
    
  }
}
