//
//  DataManager.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/28.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class EventManager: NSObject{
    
    static let sharedInstance = EventManager()
    private var eventListDescending:[Event] = []
    private var eventList:[Event] = []
    
    
    private override init() {
        super.init()
        
    }
    
    func loadList(){
        //イベントリストを一旦空にする
        eventListDescending.removeAll()
        eventList.removeAll()
        let query = NCMBQuery(className: "Event")
        var result:[NCMBObject] = []
        do{
            try result = query?.findObjects() as! [NCMBObject]
        }catch let error as NSError{
            print(error)
            return
        }
        
        if result.count > 0 {
            result.forEach{ obj in
                //                self.eventList.append(Event(event: obj))
                //イベントリストの最後尾に追加
                self.eventListDescending.insert(Event(event: obj), at: 0)
            }
            //更新日で降順にしたものを配列に追加
            eventList = eventListDescending.sorted(by: {$0.updateDate > $1.updateDate})
            print("イベントリストが更新されました")
        }
    }
    
    func getList()->[Event]{
        return self.eventList
    }
}
