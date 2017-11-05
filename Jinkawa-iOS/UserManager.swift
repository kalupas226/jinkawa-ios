//
//  UserState.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/07/13.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB

class UserManager: NSObject{
    private var userState:UserState
    static let sharedManager = UserManager()
    private var accountsList:[Accounts] = []
    
    private override init(){
        self.userState = .common
    }
    
    func getState() -> UserState{
        return self.userState
    }
    
    func setState(state:UserState){
        self.userState = state
    }
    
    func login(id:String,pass:String){
        // TestClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Accounts")
        var result:[NCMBObject] = []
        
        /** 条件を入れる場合はここに書きます **/
        query?.whereKey("userId", equalTo: id)
        query?.whereKey("password", equalTo: pass)
        // データストアの検索を実施
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("エラーが発生しました。")
            }else{
                result = objects! as! [NCMBObject]
                //検索しても見つからなかった場合
                if(result.isEmpty == true){
                    print("ログインできませんでした。")
                }else{
                // 検索成功時の処理
                    if result.count > 0 {
                        result.forEach{ obj in
                            self.accountsList.append(Accounts(accounts: obj))
                        }
                        print("アカウントリストが更新されました")
                    }
                    if self.accountsList[0].role == "admin" {
                        self.setState(state: .admin)
                        print(self.accountsList[0].role)
                        print("管理者としてログインしました。")
                    }
                }
            }
        })
    }
}

enum UserState{
    case common
    case officer
    case admin
}
