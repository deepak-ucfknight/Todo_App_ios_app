//
//  ViewController.swift
//  todoey
//
//  Created by Deepak Balaji on 1/20/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let new_item_1 = Item()
        new_item_1.title = "AcDc"
        itemArray.append(new_item_1)
        
        let new_item_2 = Item()
        new_item_2.title = "Eagles"
        itemArray.append(new_item_2)
        
        let new_item_3 = Item()
        new_item_3.title = "Pink Floyd"
        itemArray.append(new_item_3)
        
        let new_item_4 = Item()
        new_item_4.title = "Rhcp"
        itemArray.append(new_item_4)
        
       
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]  {
            itemArray = items
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
       
        let currentitem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentitem.title
        
        cell.accessoryType = currentitem.done  ? .checkmark : .none
        
        return cell
    }
    
    //table view delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //action handler
            if textField.text != nil || textField.text != "" {
                let newitem = Item()
                newitem.title = textField.text!
                self.itemArray.append(newitem)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    


}

