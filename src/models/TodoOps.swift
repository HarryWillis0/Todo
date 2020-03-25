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
    //  @return true if successfull, false otherwise
    //
    static func createTodo(_ title: String, _ description: String) -> Bool{
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // get list todo belongs to
        guard let list = ListOps.retrieveListByName(title) else { return false }
        
        // create todo
        let newTodo = Todo(context: context)
        newTodo.desc = description
        newTodo.list = list
        
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
        
        // fetch todo from db
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        fetchReq.predicate = NSPredicate(format: "desc = %@", old.desc)
        
        // extract todo from result
        do {
            let result = try context.fetch(fetchReq)
            
            if !result.isEmpty {
                let todo = result[0] as! Todo
                todo.desc = updated.desc
                todo.orderIndex = updated.orderIndex
                
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
    //  Delete a single todo by its description
    //  @param desc -> contents of the todo to delete
    //  @return true if successful, false otherwise
    //
    static func deleteItemByDesc(_ desc: String) -> Bool {
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // setup fetch request
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        fetchReq.predicate = NSPredicate(format: "desc = %@", desc)
        
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
