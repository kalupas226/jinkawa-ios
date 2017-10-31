//
//  AppDelegate.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/23.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let applicationkey = ""
    let clientkey = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NCMB.setApplicationKey("fe37c2186e22a438c980af699d831ac26d2ce6e05909c89e0677309528274a4d", clientKey: "9fd56b4ec717815b4d72081d9ae9e58192bdec9be30a416319d0069a6c33fd9f")
        
        // ファイル名を指定して画像を生成
        let fileName = "test.png"
        let imageFile = UIImage(named: fileName)
        if imageFile == nil {
            // ファイル名が無効だった場合
        }

        //////////////////////////////////////////////////////////////////////////
        // 画像をリサイズする(任意)
        /* Basic会員は５MB、Expert会員は100GBまでのデータを保存可能です */
        /* 上限を超えてしまうデータの場合はリサイズが必要です */
        let imageW : Int = Int(imageFile!.size.width*0.2) /* 20%に縮小 */
        let imageH : Int = Int(imageFile!.size.height*0.2) /* 20%に縮小 */
        let resizeImage = resize(image: imageFile!, width: imageW, height: imageH)
        //////////////////////////////////////////////////////////////////////////
 
        // 画像をNSDataに変換
        let pngData = NSData(data: UIImagePNGRepresentation(resizeImage)!)
        let file = NCMBFile.file(withName: fileName, data: pngData as Data!) as! NCMBFile
        
        // ファイルストアへ画像のアップロード
        file.saveInBackground({ (error) in
            if error != nil {
                // 保存失敗時の処理
            } else {
                // 保存成功時の処理
            }
        }) { (int) in
            // 進行状況を取得するためのBlock
            /* 1-100のpercentDoneを返す */
            /* このコールバックは保存中何度も呼ばれる */
            /*例）*/
            print("\(int)%")
        }
        
        return true
    }
    
    func resize (image: UIImage, width: Int, height: Int) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage!
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

