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
    
    @IBOutlet weak var newTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popup.layer.cornerRadius = 8

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
