//
//  AppDelegate.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/23.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let applicationkey = ""
    let clientkey = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NCMB.setApplicationKey("fe37c2186e22a438c980af699d831ac26d2ce6e05909c89e0677309528274a4d", clientKey: "9fd56b4ec717815b4d72081d9ae9e58192bdec9be30a416319d0069a6c33fd9f")
        
        // デバイストークンの要求
        if #available(iOS 10.0, *){
            /** iOS10以上 **/
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
                if error != nil {
                    // エラー時の処理
                    print("error")
                    return
                }
                if granted {
                    // デバイストークンの要求
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        } else {
            /** iOS8以上iOS10未満 **/
            //通知のタイプを設定したsettingを用意
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            //通知のタイプを設定
            application.registerUserNotificationSettings(setting)
            //DevoceTokenを要求
            UIApplication.shared.registerForRemoteNotifications()
        }
        return true
        
    }
    
    // デバイストークンが取得されたら呼び出されるメソッド
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 端末情報を扱うNCMBInstallationのインスタンスを作成
        let installation : NCMBInstallation = NCMBInstallation.current()
        // デバイストークンの設定
        installation.setDeviceTokenFrom(deviceToken)
        // 端末情報をデータストアに登録
        installation.saveInBackground {error in
            if error != nil {
                // 端末情報の登録に失敗した時の処理
            } else {
                // UserDefaultsを使ってフラグを保持する
                let userDefault = UserDefaults.standard
                // "firstLaunch"をキーに、Bool型の値を保持する
                let dict = ["firstLaunch": true]
                // デフォルト値登録
                // ※すでに値が更新されていた場合は、更新後の値のままになる
                userDefault.register(defaults: dict)
                
                // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
                if userDefault.bool(forKey: "firstLaunch") {
                    userDefault.set(false, forKey: "firstLaunch")
                    // 端末情報の登録に成功した時の処理
                    let currentInstallation = NCMBInstallation.current()
                    if (currentInstallation?.deviceToken == nil) {
                        return
                    }
                    currentInstallation?.setObject(["on"], forKey: "channels")
                    currentInstallation?.saveInBackground{(error) -> Void in
                        if ((error == nil)) {
                            print("updatechannels complete")
                        } else {
                            print("updatechannels error: \(String(describing: error))")
                        }
                    }
                }
            }
        }
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
        //バッジの数を０にする.
        UIApplication.shared.applicationIconBadgeNumber = 0
        let currentInstallation = NCMBInstallation.current()
        if (currentInstallation?.deviceToken == nil) {
            return
        }
        
        // installation class update
        currentInstallation?.setObject(0, forKey: "badge")
        currentInstallation?.saveInBackground{(error) -> Void in
            if ((error == nil)) {
                print("updateBadgeNumber complete")
            } else {
                print("updateBadgeNumber error: \(String(describing: error))")
            }
        }
        
        //プッシュ通知メッセージの更新
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .authorized:
                SettingViewController.pushStr = "アプリを強制終了すると、通知が遅れたり、受信できない場合があります。"
                break
            case .denied:
                SettingViewController.pushStr = "端末のじぷりの通知設定がオフのようです。じぷりの通知設定を有効にするためには、端末の設定画面で「じぷり」の通知をオンにしてください。"
                break
            case .notDetermined:
                break
            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

