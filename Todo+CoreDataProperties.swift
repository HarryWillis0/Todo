//
//  Todo+CoreDataProperties.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-22.
//  Copyright © 2020 harry. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var orderIndex: Int32
    @NSManaged public var desc: String
    @NSManaged public var list: List

}
