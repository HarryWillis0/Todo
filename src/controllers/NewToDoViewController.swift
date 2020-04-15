//
//  NewToDoViewController.swift
//  ToDo
//
//  Created by Harry George Willis on 2020-03-25.
//  Copyright © 2020 harry. All rights reserved.
//

import UIKit
import NotificationCenter

class NewToDoViewController: UIViewController {
    
    @IBOutlet weak var popup: UIView!
    
    @IBOutlet weak var txtFieldNewTodo: UITextField!
    
    var newTodo: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        popup.layer.cornerRadius = 8
        
        // listen on when keyboard will appear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // listen on when keyboard will dissappear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // slide view up when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        // get keyboard height
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {
                return
            }
        let offset = keyboardFrame.cgRectValue.height
        // move view up
        popup.frame.origin.y = offset - 50
    }
    
    // slide view back to center when keyboard hides
    @objc func keyboardWillHide(notification: NSNotification) {
        // move view back
        popup.frame.origin.y = 0
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
