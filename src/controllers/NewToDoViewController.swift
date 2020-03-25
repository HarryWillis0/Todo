//
//  NewToDoViewController.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-25.
//  Copyright © 2020 harry. All rights reserved.
//

import UIKit

class NewToDoViewController: UIViewController {

    @IBOutlet weak var popup: UIView!
    
    @IBOutlet weak var txtFieldNewTodo: UITextField!
    
    var newTodo: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        popup.layer.cornerRadius = 8
    }
    

    
    // MARK: - Navigation
    // validate
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveNewToDo" {
            // don't want empty titles
            if txtFieldNewTodo.text == "" {
                let alert = UIAlertController(title: "Empty ToDo", message: "Please enter a ToDo.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set newTodo to text inside txtFieldNewTodo
        // catch this value on other side of segue
        if (segue.identifier == "saveNewToDo") {
            newTodo = txtFieldNewTodo.text!
        }
    }

}
