//
//  User.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/11/05.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB

class Accounts: NSObject{
    
    let id:String
    let ps:String
    let auth: Array<String>
    let role:String
    let is_login:Bool
    
    override init(){
        id = ""
        ps = ""
        auth = [""]
        role = ""
        is_login = false
    }
    
    init(accounts: NCMBObject) {
        id = accounts.object(forKey: "userId") as! String
        ps = accounts.object(forKey: "password") as! String
        auth = accounts.object(forKey: "auth") as! Array
        role = accounts.object(forKey: "role") as! String
        is_login = accounts.object(forKey: "is_login") as! Bool
    }
    init(id:String, ps:String, auth:Array<String>, role:String, is_login:Bool){
        self.id = id
        self.ps = ps
        self.auth = auth
        self.role = role
        self.is_login = is_login
    }
    
    func save(){
        let accountsObject = NCMBObject(className: "Accounts")
        accountsObject?.setObject(id, forKey: "userId")
        accountsObject?.setObject(ps, forKey: "password")
        accountsObject?.setObject(auth, forKey: "auth")
        accountsObject?.setObject(role, forKey: "role")
        accountsObject?.setObject(is_login, forKey: "is_login")
        
        accountsObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })
        
    }
}

