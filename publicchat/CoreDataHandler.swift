//
//  CoreDataHandler.swift
//  publicchat
//
//  Created by DavidTran on 2/15/18.
//  Copyright © 2018 DavidTran. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoreDataHandler:NSObject{
    static func getContext() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate! as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    static func savedHistoryObject(conversationId:String,date:Date,isMyMessage:Bool,message:String) -> Bool{
        
 
        // Save Conversation
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ChatHistory", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(conversationId, forKey: "conversationid")
        manageObject.setValue(date, forKey: "dateofms")
        manageObject.setValue(isMyMessage, forKey: "ismymessage")
        manageObject.setValue(message, forKey: "message")
        do {
            try context.save()
            let delegate = UIApplication.shared.delegate! as! AppDelegate
           
            return true
        } catch {
            print(error)
            return false
        }
    }
    static func fetchHistoryData()->[ChatHistory]{
        let context = getContext()
        var array = [ChatHistory]()
        do {
            array = try context.fetch(ChatHistory.fetchRequest())
            return array
        } catch {
            print(error)
            return array
        }
    }
}
