//
//  FriendHistory+CoreDataProperties.swift
//  
//
//  Created by DavidTran on 2/15/18.
//
//

import Foundation
import CoreData


extension FriendHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendHistory> {
        return NSFetchRequest<FriendHistory>(entityName: "FriendHistory")
    }

    @NSManaged public var friendid: String?

}
