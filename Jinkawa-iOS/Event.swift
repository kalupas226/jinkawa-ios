//
//  Event.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB

class Event: NSObject{
    
    let name: String
    let updateDate: String
    let descriptionText: String
    let day: String
    let location: String
    let departmentName: String
    let id: String
    
    override init(){
        name = ""
        updateDate = ""
        descriptionText = ""
        day = ""
        location = ""
        departmentName = ""
        id = ""
    }
    
    init(event: NCMBObject) {
        name = event.object(forKey: "event_name") as! String
        updateDate = event.object(forKey: "update_date") as! String
        descriptionText = event.object(forKey: "description") as! String
        day = event.object(forKey: "day") as! String
        location = event.object(forKey: "location") as! String
        departmentName = event.object(forKey: "event_department_name") as! String
        id = event.object(forKey: "objectId") as! String
    }
    
    init(name: String, descriptionText: String, day: String, location: String, departmentName:String) {
        self.name = name
        self.updateDate = String(describing: Date())
        self.descriptionText = descriptionText
        self.day = day
        self.location = location
        self.departmentName = departmentName
        self.id = ""
    }
    
    func save(){
        let eventObject = NCMBObject(className: "Event")
        eventObject?.setObject(name, forKey: "event_name")
        eventObject?.setObject(updateDate, forKey: "update_date")
        eventObject?.setObject(descriptionText, forKey: "description")
        eventObject?.setObject(day, forKey: "day")
        eventObject?.setObject(location, forKey: "location")
        eventObject?.setObject(departmentName, forKey: "event_department_name")
        
        eventObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })

    }
}
