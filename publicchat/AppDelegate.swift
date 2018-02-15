//
//  AppDelegate.swift
//  publicchat
//
//  Created by DavidTran on 2/12/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import UIKit
import UserNotifications
import SocketIO
import AVFoundation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioPlayer = AVPlayer()
    
    func setupSlientAudio(){
        do {
            audioPlayer = try AVPlayer(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "1h20m_silent_audio", ofType: "mp3")!))
            
            var audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupSlientAudio()
        audioPlayer.play()
        
        // Override point for customization after application launch.
        // Request Permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {
            granted, error in
            if granted {
                print("Approval granted to send notifications")
            } else {
                print(error)
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //SocketIOManager.sharedInstance.establishConnection()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        audioPlayer.play()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("app exit")
        self.saveContext()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HistoryModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func presentToChatView(of userID:String){
        if let topController = window?.visibleViewController() {
            print(topController)
            
            if topController.isKind(of: FriendListTableViewController.self){
                var currentController = topController as! FriendListTableViewController
                currentController.selectedId = String(userID)
                currentController.selectedName = String(userID)
                currentController.performSegue(withIdentifier: "ChatVCSegue", sender: nil)
            }
            else if topController.isKind(of: ChatViewController.self){
                //var currentController = topController as! ChatViewController
                topController.navigationController?.popViewController(animated: true)
                
                var currentController = window?.visibleViewController() as! FriendListTableViewController
                currentController.selectedId = userID
                currentController.selectedName = userID
                currentController.performSegue(withIdentifier: "ChatVCSegue", sender: nil)
            }
        }
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print (response.notification.request.identifier)
        print("touched notif")
        let fromUserIDRaw = response.notification.request.identifier
        let indexEndOfText = fromUserIDRaw.index(fromUserIDRaw.endIndex, offsetBy: -2)
        let userID = fromUserIDRaw[..<indexEndOfText]
        print(userID)
        
        presentToChatView(of: String(userID))
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
   

}

