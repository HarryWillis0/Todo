//
//  ListOps.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-22.
//  Copyright © 2020 harry. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ListOps {
    //
    //  Create a new list from supplied title
    //  @param title -> title of new list
    //
    static func createList(_ title: String) {
        // get container
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get context
        let context = appDel.persistentContainer.viewContext
        
        // create list
        let newList = List(context: context)
        newList.title = title
        newList.dateCreated = Date()
        newList.todos = nil
        
        // save to db
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //
    //  Retrieve all lists from database
    //  @returns lists -> an array of list objects
    //
    static func retrieveLists() -> [List]? {
        var lists = [List]()
        
        // get container
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [List]() }
        
        // get context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // prepare request
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        // execute fetch
        do{
            let result = try managedContext.fetch(fetchReq)
            for data in result as! [NSManagedObject] {
                lists.append(data as! List)
            }
        } catch let error as NSError{
            print("Could not retrieve lists. \(error), \(error.userInfo)")
        }
        
        return lists
    }
    
    //
    //  Retrieve a single list by its title
    //  @param title -> title of list to retrieve
    //
    static func retrieveListByName(_ title: String) -> List? {
        var list = List()
        
        // get container
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        // get context
        let context = appDelegate.persistentContainer.viewContext
        
        // prepare request
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        fetchReq.predicate = NSPredicate(format: "title = %@", title)
        
        // execute fetch request
        do {
            let result = try context.fetch(fetchReq)
            
            // make sure found list
            if !result.isEmpty {
                list = result[0] as! List
            }
            
        } catch let error as NSError {
            print("Couldn't find list. \(error), \(error.userInfo)")
        }
        
        return list
    }
    
    //
    //  Delete a single list by its title
    //  @param title -> title of list to delete
    //  @return true if successfull, false otherwise
    //
    static func deleteListByName(_ title: String) -> Bool {
        // get container
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // get context
        let context = appDelegate.persistentContainer.viewContext
        
        // setup fetch request
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "List")
        fetchReq.predicate = NSPredicate(format: "title = %@", title)
        
        // execute fetch request
        do {
            let list = try context.fetch(fetchReq)
            
            // make sure a result
            if !list.isEmpty {
                context.delete(list[0])
                
                // save to db
                do {
                    try context.save()
                    return true
                } catch let error as NSError {
                    print("Unable to save delete list. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Unable to delete list. \(error), \(error.userInfo)")
        }
        return false
    }
}
