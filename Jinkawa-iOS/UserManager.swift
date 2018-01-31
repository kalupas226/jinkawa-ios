//
//  UserState.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/07/13.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB
import UIKit

class UserManager: NSObject {
    private var userState:UserState
    static let sharedInstance = UserManager()
    
    private override init(){
        self.userState = .common
    }
    
    func getState() -> UserState{
        return self.userState
    }
    
    func setState(state:UserState){
        self.userState = state
    }
}

enum UserState{
    case common
    case officer
    case admin
}

