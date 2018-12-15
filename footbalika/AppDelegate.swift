//
//  AppDelegate.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 3/20/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {    

    var window: UIWindow?

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool
    {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func signIn(_ signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!)
    {
        if (error == nil) {
            // Perform any operations on signed in user here.
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(_ signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        print("user disconnected")
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize sign-in
        print("didFinishLaunchingWithOptions")

        GIDSignIn.sharedInstance().clientID = "520243797362-c4vbajl2astro69oi18eh8cs405jto7i.apps.googleusercontent.com"
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "انجام شد"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyBoard = UIStoryboard(name: "iPhoneX", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "loadingViewController") as! loadingViewController
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
                
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "loadingViewController") as! loadingViewController
//                let viewController = storyBoard.instantiateViewController(withIdentifier: "testTapsellViewController") as! testTapsellViewController
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
            
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyBoard = UIStoryboard(name: "iPad", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "loadingViewController") as! loadingViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")

        let playMenuMusics = UserDefaults.standard.bool(forKey: "menuMusic")
        if playMenuMusics {
        if musicPlay.musicPlayer?.isPlaying == true {
            DispatchQueue.main.async {
                musicPlay.musicPlayer?.pause()
                print("music Off")
            }
        }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        

        if StoreViewController.packageShowAfterWeb != "" {
        print(StoreViewController.packageShowAfterWeb)
        NotificationCenter.default.post(name: Notification.Name("showingBoughtItem"), object: nil, userInfo: nil)
        }
//        NotificationCenter.default.post(name: Notification.Name("updateTimer"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        let playMenuMusics = UserDefaults.standard.bool(forKey: "menuMusic")
        if playMenuMusics {
            musicPlay.musicPlayer?.play()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    
}

