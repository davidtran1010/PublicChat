//
//  ChatHistory+CoreDataProperties.swift
//  
//
//  Created by DavidTran on 2/15/18.
//
//

import Foundation
import CoreData


extension ChatHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatHistory> {
        return NSFetchRequest<ChatHistory>(entityName: "ChatHistory")
    }

    @NSManaged public var conversationid: String?
    @NSManaged public var message: String?
    @NSManaged public var dateofms: NSDate?
    @NSManaged public var ismymessage: Bool



}
