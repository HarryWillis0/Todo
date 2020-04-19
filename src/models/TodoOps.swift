//
//  TodoOps.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-22.
//  Copyright © 2020 harry. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// CRUD operations on ToDo entity
class TodoOps {
    //
    //  Create a new Todo entity, set up relationship with supplied list
    //  @param title -> title of list to associate new todo with
    //  @param description -> contents of new todo
    //  @param order -> order of todo 
    //  @return true if successfull, false otherwise
    //
    static func createTodo(_ title: String, _ description: String, _ order: Int32) -> Bool{
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // get list todo belongs to
        guard let list = ListOps.retrieveListByName(title) else { return false }
        
        // create todo
        let newTodo = Todo(context: context)
        newTodo.desc = description
        newTodo.dateCreated = NSDate.init()
        newTodo.list = list
        newTodo.done = false
        newTodo.orderIndex = order
        
        // add todo to list
        list.addToTodos(newTodo)
        
        // save to db
        do {
            try context.save()
            return true
        } catch let error as NSError {
            print("Could not save new item. \(error), \(error.userInfo)")
        }
        return false
    }
    
    //
    //  Update a todo
    //  @param old -> old object used to find
    //  @param updated -> updated todo object
    //
    static func updateTodo(_ old: Todo, _ updated: Todo) {
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // fetch todo from db according to its date created and its description
        // this lets us have multiple todos of the same description
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        let descPredicate = NSPredicate(format: "desc = %@", old.desc)
        let datePredicate = NSPredicate(format: "dateCreated = %@", old.dateCreated)
        let andPredicate = NSCompoundPredicate.init(type: NSCompoundPredicate.LogicalType.and, subpredicates: [descPredicate, datePredicate])
        fetchReq.predicate = andPredicate
        
        // extract todo from result
        do {
            let result = try context.fetch(fetchReq)
            
            if !result.isEmpty {
                let todo = result[0] as! Todo
                todo.desc = updated.desc
                todo.orderIndex = updated.orderIndex
                todo.done = updated.done
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Unable to update todo. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError{
            print("Unable to find todo. \(error), \(error.userInfo)")
        }
        
    }
    
    //
    //  Delete a single todo by its description and date created
    //  @param desc -> contents of the todo to delete
    //  @param dateCreated -> date created of todo to delete
    //  @return true if successful, false otherwise
    //
    static func deleteItemByDesc(_ desc: String, _ dateCreated: NSDate) -> Bool {
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // fetch todo from db according to its date created and its description
        // this lets us have multiple todos of the same description
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        let descPredicate = NSPredicate(format: "desc = %@", desc)
        let datePredicate = NSPredicate(format: "dateCreated = %@", dateCreated)
        let andPredicate = NSCompoundPredicate.init(type: NSCompoundPredicate.LogicalType.and, subpredicates: [descPredicate, datePredicate])
        fetchReq.predicate = andPredicate
        
        // execute fetch
        do {
            let todo = try context.fetch(fetchReq)
            
            // make sure we actually found something
            if !todo.isEmpty {
                context.delete(todo[0])
                
                // save to db
                do {
                    try context.save()
                    return true
                } catch let error as NSError {
                    print("Unable to save delete item. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Unable to delete list. \(error), \(error.userInfo)")
        }
        return false
    }
}
