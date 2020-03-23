//
//  List+CoreDataProperties.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-22.
//  Copyright © 2020 harry. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var title: String
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension List {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
