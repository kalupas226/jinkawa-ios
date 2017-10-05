//
//  Participant.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB

class Participant: NSObject{
    
    let name:String
    let gender:String
    let age: String
    let tell:String
    let address:String
    
    let event_id:String
    
    init(participant: NCMBObject) {
        name = participant.object(forKey: "name") as! String
        gender = participant.object(forKey: "sex") as! String
        age = participant.object(forKey: "age") as! String
        tell = participant.object(forKey: "tell") as! String
        address = participant.object(forKey: "address") as! String
        event_id = participant.object(forKey: "eventID") as! String
    }
    init(name:String, gender:String, age:String, tell: String, address:String, event_id:String){
        self.name = name
        self.gender = gender
        self.age = age
        self.tell = tell
        self.address = address
        self.event_id = event_id
    }
    
    func save(){
        let participantObject = NCMBObject(className: "Participants")
        participantObject?.setObject(name, forKey: "name")
        participantObject?.setObject(gender, forKey: "sex")
        participantObject?.setObject(age, forKey: "age")
        participantObject?.setObject(tell, forKey: "tell")
        participantObject?.setObject(address, forKey: "address")
        participantObject?.setObject(event_id, forKey: "eventID")
        
        participantObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })

    }
}
