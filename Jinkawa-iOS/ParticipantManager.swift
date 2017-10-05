//
//  ParticipantModel.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class ParticipantManager: NSObject{
    
    static let sharedInstance = ParticipantManager()
    private var participantList:[Participant] = []
    
    
    private override init() {
        super.init()
        
    }
    
    func loadList(){
        let query = NCMBQuery(className: "Participants")
        var result:[NCMBObject] = []
        do{
            try result = query?.findObjects() as! [NCMBObject]
        }catch let error as NSError{
            print(error)
            return
        }
        
        if result.count > 0 {
            result.forEach{ obj in
                self.participantList.append(Participant(participant: obj))
            }
            print("参加者リストが更新されました")
        }
    }
    
    func getList()->[Participant]{
        return self.participantList
    }
    
    func getList(event_id: String)->[Participant]{
        return self.getList().filter{$0.event_id == event_id}
    }
}

