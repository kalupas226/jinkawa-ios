//
//  InfomationModel.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/07/09.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class InformationManager: NSObject{
    
    static let sharedInstance = InformationManager()
    private var informationList:[Information] = []
    
    
    private override init() {
        super.init()
        
    }
    
    func loadList(){
        let query = NCMBQuery(className: "Information")
        var result:[NCMBObject] = []
        do{
            try result = query?.findObjects() as! [NCMBObject]
        }catch let error as NSError{
            print(error)
            return
        }
        
        if result.count > 0 {
            result.forEach{ obj in
                self.informationList.append(Information(information: obj))
            }
            print("お知らせリストが更新されました")
        }
    }
    
    func getList()->[Information]{
        return self.informationList
    }
}
