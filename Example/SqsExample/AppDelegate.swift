//
//  AppDelegate.swift
//  SqsExample
//
//  Created by chchrn on 6/9/20.
//  Copyright © 2020 chchrn. All rights reserved.
//

import Sqs
import UIKit
import wlog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var webService: WsWebService?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.webService = WsWebServiceLog(
            WsWebServiceOnUrlSession(urlSession: URLSession.shared, maxConcurrentOperationCount: 20),
            log: OsLog(category: "network")
        )
        self.webService?.send(request: TestWebQuery().request()!,
                              priority: 1.0,
                              progressBlock: nil)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
