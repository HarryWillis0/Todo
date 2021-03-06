//
//  Todo+CoreDataProperties.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-04-15.
//  Copyright © 2020 harry. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var desc: String?
    @NSManaged public var done: Bool
    @NSManaged public var orderIndex: Int32
    @NSManaged public var dateCreated: Date?
    @NSManaged public var list: List?

}
