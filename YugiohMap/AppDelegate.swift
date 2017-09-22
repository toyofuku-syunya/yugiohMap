//
//  AppDelegate.swift
//  YugiohMap
//
//  Created by Syunya Toyofuku on 2017/06/09.
//  Copyright © 2017年 Syunya Toyofuku. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


let ref = Database.database().reference()

// Get a reference to the storage service using the default Firebase App
let storage = Storage.storage()

// Create a storage reference from our storage service
let storageRef = storage.reference()




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    // Get a reference to the storage service using the default Firebase App

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //Firebase Database サンプルコード...Appの読み込み時に実行されるので、コードからデータベースを操作したい時はここに記載する。
        //        ref.child("shopData").child("narakan").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
        //            // Get user value
        //            let value = snapshot.value as! String
        //            print("this is value \(value)")
        //            print(snapshot.value as! String)
        //        })
        
        //時間からデータを作成してevaluationのデータディレクトリを作成してディレクトリの下にサンプルデータを1つ作成した。
        //        var dic: Dictionary<String, Any>!
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //
        //        let data = ["\(formatter)": "5"]
        //
        //        ref.child("shopData").observeSingleEvent(of: .value, with: {(snapshot) in
        //            dic = snapshot.value as! [String:Any]
        //
        //            for name in dic!.keys {
        //             ref.child("shopData").child("\(name)").child("evaluation").updateChildValues(data)
        //            }
        //        })
        return true
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
