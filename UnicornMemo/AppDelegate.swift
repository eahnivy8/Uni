//
//  AppDelegate.swift
//  UnicornMemo
//
//  Created by Eddie Ahn on 2020/04/27.
//  Copyright © 2020 Sang Wook Ahn. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithOpaqueBackground()
                //let colorLiteral = #colorLiteral(red: 0.8302105069, green: 0.964060843, blue: 1, alpha: 1)
            coloredAppearance.backgroundColor = .clear
                coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemPurple]
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemPurple]
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            } else {
                // Fallback on earlier versions
            }
            CoreDataManager.shared.setup(modelName: "UnicornMemo")
            CoreDataManager.shared.fetchMemo()
            //initialize Firebase
            FirebaseApp.configure()
            //initialize AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)

//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
//        ["acc01697ee9ac4021ee952ed642c1c90"] // Sample device ID
            return true
        }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

