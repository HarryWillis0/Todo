//
//  ListDetailsTableViewController.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-25.
//  Copyright © 2020 harry. All rights reserved.
//

import UIKit

class ListDetailsTableViewController: UITableViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    
    var currList: List = List()
    
    var todos: [Todo] = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get items for that list and order on their order property
        //      (this allows us to save the ordering that user sets up)
        let set: NSSet? = currList.todos
        todos = set?.allObjects as! [Todo]
        self.todos.sort { $0.orderIndex < $1.orderIndex}
        
        // set title
        navBar.title = currList.title
        // edit button on nav bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        for todo in todos {
            print("todo: \(todo.desc) \(todo.orderIndex)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = todos[indexPath.row].desc

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // successful delete
            if TodoOps.deleteItemByDesc(todos[indexPath.row].desc) {
                // delete from lists array
                todos.remove(at: indexPath.row)
                
                // delete row from taableview
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // reload and display lists
                loadTodos()
            } else { // unsuccessful
                // alert unsuccessful
                let alert = UIAlertController(title: "Delete Todo Error", message: "Sorry, we weren't able to delete your  todo.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // get todo moved
        let moved = self.todos[fromIndexPath.row]
        
        // remove it
        todos.remove(at: fromIndexPath.row)
        
        // insert at new position
        todos.insert(moved, at: to.row)
        
        let olds = saveOrder()
        
        // update each todo (save their order)
        for (index, todo) in self.todos.enumerated() {
            TodoOps.updateTodo(olds[index], todo)
        }
    }

    
    // MARK: - Navigation
    
    // handle return segues from cancel button
    @IBAction func cancel(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    // handle return segue from save button
    @IBAction func save(segue: UIStoryboardSegue) {
        // catch new todo
        if segue.identifier == "saveNewToDo" {
            let newToDoVC = segue.source as! NewToDoViewController
            // new todo added successfully
            if (TodoOps.createTodo(currList.title, newToDoVC.newTodo)) {
                // reload items and display
                loadTodos()
            } else { // added unsuccessfully
                // alert unsuccessful
                let alert = UIAlertController(title: "New ToDo Error", message: "Sorry, we weren't able to save your new todo.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - helpers
    
    // regather current list's todos and display
    func loadTodos() {
        // get items for that list and order on their order property
        let set: NSSet? = currList.todos
        todos = set?.allObjects as! [Todo]
        self.todos.sort { $0.orderIndex < $1.orderIndex}
        
        self.tableView.reloadData()
    }
    
    // save current order of list's todos
    func saveOrder() -> [Todo] {
        var oldTodos = [Todo]()
        for (index, todo) in self.todos.enumerated() {
            oldTodos.append(todo)
            todo.orderIndex = Int32(index)
        }
        return oldTodos
    }
}
