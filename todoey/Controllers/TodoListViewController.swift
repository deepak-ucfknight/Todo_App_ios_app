//
//  ViewController.swift
//  todoey
//
//  Created by Deepak Balaji on 1/20/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var items : Results<Items>?
    
    var selectedCategory : Categories?    {
        didSet {
            loadItems()
            tableView.separatorStyle = .none
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
   
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
         tableView.rowHeight = 80.0
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.cellColorCode {
            
            title = selectedCategory!.name
            
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
            
            if let navbarcolor = UIColor(hexString : colorHex) {
            
                navBar.barTintColor = navbarcolor
                
                navBar.tintColor = ContrastColorOf(navbarcolor, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarcolor, returnFlat: true)]
                
                searchBarOutlet.barTintColor = navbarcolor
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard  let OriginalColor =  FlatRed().lighten(byPercentage: CGFloat(0.5)) else {fatalError()}
        
        navigationController?.navigationBar.barTintColor = OriginalColor
        
        navigationController?.navigationBar.tintColor = ContrastColorOf(OriginalColor, returnFlat: true)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(OriginalColor, returnFlat: true)]
    }
    
    //table view datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            
            if let color = UIColor(hexString: item.cellColorCode)?.darken(byPercentage: CGFloat(Double(indexPath.row) * 0.5) / CGFloat(items!.count)) {
            
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            
            cell.textLabel?.text = "No items Added Yet"
        }
        
        return cell
    }
    
    //table view delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //action handler
            if textField.text != nil || textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            
                            let newItem = Items()
                            newItem.title = textField.text!
                            newItem.done = false
                            newItem.dateCreated = Date()
                            newItem.cellColorCode = self.selectedCategory?.cellColorCode ?? UIColor.white.hexValue()
                            currentCategory.items.append(newItem)
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
        
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(item: Items) {

        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }

        tableView.reloadData()
    }
    
    func loadItems() {
        
        items  = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func deleteActionHandler(at indexPath: IndexPath) {
        
        if let itemForDeletion = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                
            }
        }
    }

    

}

//Extension of the todolistviewcontroller for searchbar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

       items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


