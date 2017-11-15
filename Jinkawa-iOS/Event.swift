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
    let dateStart: String
    let dateEnd: String
    let timeStart: String
    let timeEnd: String
    let location: String
    let departmentName: String
    let id: String
    let capacity: String
    let officer: Bool
    let deadline: String
    
    override init(){
        name = ""
        updateDate = ""
        descriptionText = ""
        dateStart = ""
        dateEnd = ""
        timeStart = ""
        timeEnd = ""
        location = ""
        departmentName = ""
        id = ""
        capacity = ""
        officer = false
        deadline = ""
    }
    
    init(event: NCMBObject) {
        name = event.object(forKey: "name") as! String
        updateDate = event.object(forKey: "updateDate") as! String
        descriptionText = event.object(forKey: "description") as! String
        dateStart = event.object(forKey: "date_start") as! String
        dateEnd = event.object(forKey: "date_end") as! String
        timeStart = event.object(forKey: "start_time") as! String
        timeEnd = event.object(forKey: "end_time") as! String
        location = event.object(forKey: "location") as! String
        departmentName = event.object(forKey: "department") as! String
        id = event.object(forKey: "objectId") as! String
        capacity = event.object(forKey: "capacity") as! String
        officer = event.object(forKey: "officer_only") as! Bool
        deadline = event.object(forKey: "deadline_day") as! String
    }
    
    init(name: String, descriptionText: String, dateStart: String, dateEnd: String, timeStart: String, timeEnd: String, location: String, departmentName:String, capacity: String, officer:Bool, deadline: String) {
        self.name = name
        self.updateDate = String(describing: Date())
        self.descriptionText = descriptionText
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.location = location
        self.departmentName = departmentName
        self.id = ""
        self.capacity = capacity
        self.officer = officer
        self.deadline = deadline
    }
    
    func save(){
        let eventObject = NCMBObject(className: "Event")
        eventObject?.setObject(name, forKey: "name")
        eventObject?.setObject(updateDate, forKey: "update_date")
        eventObject?.setObject(descriptionText, forKey: "description")
        eventObject?.setObject(dateStart, forKey: "date_start")
        eventObject?.setObject(dateEnd, forKey: "date_end")
        eventObject?.setObject(timeStart, forKey: "start_time")
        eventObject?.setObject(timeEnd, forKey: "end_time")
        eventObject?.setObject(location, forKey: "location")
        eventObject?.setObject(departmentName, forKey: "department")
        eventObject?.setObject(capacity, forKey: "capacity")
        eventObject?.setObject(officer, forKey: "officer_only")
        eventObject?.setObject(deadline, forKey: "deadline_day")
        
        eventObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })

    }
}
