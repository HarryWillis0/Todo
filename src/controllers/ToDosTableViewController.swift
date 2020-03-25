//
//  ToDosTableViewController.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-17.
//  Copyright © 2020 harry. All rights reserved.
//

import UIKit

class ToDosTableViewController: UITableViewController {

    var lists: [List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve lists from db
        lists = ListOps.retrieveLists()!
        
        // edit button in navbar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = lists[indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // successful delete
            if ListOps.deleteListByName(lists[indexPath.row].title) {
                // delete from lists array
                lists.remove(at: indexPath.row)
                
                // delete row from taableview
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // reload and display lists
                lists = ListOps.retrieveLists()!
                tableView.reloadData()
            } else { // unsuccessful
                // alert unsuccessful
                let alert = UIAlertController(title: "Delete List Error", message: "Sorry, we weren't able to delete your  list.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // MARK: - Navigation
    
    // handle return segues from cancel button
    @IBAction func cancel(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    // handle return segue from save button
    @IBAction func save(segue: UIStoryboardSegue) {
        // catch new list title
        if segue.identifier == "saveNewList" {
            let newListVC = segue.source as! NewTodoViewController
            
            // save successful
            if ListOps.createList(newListVC.newTitle) {
                
                // reload lists
                lists = ListOps.retrieveLists()!
                self.tableView.reloadData()
            } else { // save unsuccesful
                
                // alert unsuccessful
                let alert = UIAlertController(title: "New List Error", message: "Sorry, we weren't able to save your new list.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
