//
//  NewTodoViewController.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-22.
//  Copyright © 2020 harry. All rights reserved.
//

import UIKit

class NewTodoViewController: UIViewController {

    @IBOutlet weak var popup: UIView!
    
    @IBOutlet weak var txtFieldNewTitle: UITextField!
    
    var newTitle: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popup.layer.cornerRadius = 8

    }
    
    // MARK: - Navigation

    // validate
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveNewList" {
            // don't want empty titles
            if txtFieldNewTitle.text == "" {
                let alert = UIAlertController(title: "Empty Title", message: "Please enter a list title.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set newTitle to text inside newTitleText field
        // catch this value on other side of segue
        if (segue.identifier == "saveNewList") {
            newTitle = txtFieldNewTitle.text!
        }
    }
}
