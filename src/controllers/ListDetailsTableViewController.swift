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

    // don't allow highlighting
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        // is todo already done? strikethrough if so
        if todos[indexPath.row].done {
            // build striked string
            let striked: NSAttributedString = buildStriked(todos[indexPath.row].desc)
            cell.textLabel?.attributedText = striked
        } else {
            // build unstriked
            let unstriked: NSAttributedString = buildUnstriked(todos[indexPath.row].desc)
            cell.textLabel?.attributedText = unstriked
        }

        return cell
    }
    
    // animate cell load
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // simple fade animation
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
        
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
    
    // swiping right on cell to strikethrough todo
    // update todos done property so we can save the strike through for next app load
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let swipeAct: UIContextualAction = UIContextualAction(style: .normal, title: "Done!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // if already done do nothing
            /*if self.todos[indexPath.row].done {
                success(true)
                return
            }*/
            
            // build striked string and set cell text to it
            let striked: NSAttributedString =  self.buildStriked(tableView.cellForRow(at: indexPath)!.textLabel!.text!)
            
            // build transition
            let transition = self.buildStrikeTransition()
            
            // set cell text with transition
            tableView.cellForRow(at: indexPath)!.textLabel?.attributedText = striked
            tableView.cellForRow(at: indexPath)!.textLabel?.layer.add(transition, forKey: kCATransition)
            
            // update todo
            self.updateDone(true, self.todos[indexPath.row])
            success(true)
        })
        
        swipeAct.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [swipeAct])
    }
    
    // swiping left on cell to undo strike through
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAct: UIContextualAction = UIContextualAction(style: .normal, title: "Not done", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // if already not done do nothing
            if !self.todos[indexPath.row].done {
                success(true)
                return
            }
            
            // go build unstriked version of todo desc
            let unstriked: NSAttributedString = self.buildUnstriked(self.todos[indexPath.row].desc)
            
            // build transition
            let transition = self.buildUnstrikeTransition()
            
            // set cell text with transition
            tableView.cellForRow(at: indexPath)!.textLabel!.attributedText = unstriked
            tableView.cellForRow(at: indexPath)!.textLabel?.layer.add(transition, forKey: kCATransition)
            
            // update todo
            self.updateDone(false, self.todos[indexPath.row])
            success(true)
        })
        
        swipeAct.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [swipeAct])
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
    
    // update the done state of a todo object to value
    func updateDone(_ value: Bool, _ todo: Todo) {
        let index = self.tableView.indexPathForSelectedRow?.row ?? 0
        //save old one
        let old: Todo = self.todos[index]
        self.todos[index].done = value
        TodoOps.updateTodo(old, self.todos[index])
    }
    
    // build striked through string from current todo description
    func buildStriked(_ desc: String) -> NSAttributedString {
        // set up some attributes
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)
        ]
        // build string with above attributes
        let striked : NSMutableAttributedString =  NSMutableAttributedString(string: desc, attributes: attributes)
        
        return striked
    }
    
    // build unstriked string for resetting todo to undone
    func buildUnstriked(_ desc: String) -> NSAttributedString {
        // set up some attributes
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)
        ]
        
        let unstriked: NSMutableAttributedString = NSMutableAttributedString(string: desc, attributes: attributes)
        
        return unstriked
    }
    
    // build strike through transition
    func buildStrikeTransition() -> CATransition {
        let transition: CATransition = CATransition()
        
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.duration = 0.5
        
        return transition
    }
    
    // build unstrike transition
    func buildUnstrikeTransition() -> CATransition {
        let transition: CATransition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.duration = 0.5
        return transition
    }
}
