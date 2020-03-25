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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                // save order
                saveOrder()
                // reload items and display
                loadItems()
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
    func loadItems() {
        // get items for that list and order on their order property
        let set: NSSet? = currList.todos
        todos = set?.allObjects as! [Todo]
        self.todos.sort { $0.orderIndex < $1.orderIndex}
        
        self.tableView.reloadData()
    }
    
    // save current order of list's todos
    func saveOrder() {
        for (index, todo) in self.todos.enumerated() {
            todo.orderIndex = Int32(index)
        }
    }
}
