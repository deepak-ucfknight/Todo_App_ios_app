//
//  CategoryViewController.swift
//  todoey
//
//  Created by Deepak Balaji on 1/21/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
        
    }

    
    @IBAction func addbarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
         let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil || textField.text != "" {
                
                let newitem = Category(context: self.context)
                
                newitem.name = textField.text!
                
                
                self.categories.append(newitem)
                
                self.saveData()
                
                for category in self.categories {
                    print(category.name!)
                }
            }
            
        }
        
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
        }
        
        present(alert, animated: true,completion: nil)
        
    }
    
    //Table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let currentcategory = categories[indexPath.row]
        
        cell.textLabel?.text = currentcategory.name
        
        return cell
        
    }
    
    //Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Segue Preparation")
        
        if segue.identifier == "goToItems" {
            
             let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                destinationVC.selectedCategory = self.categories[indexPath.row]
            }
            
           
        }
        
       
    }
    
    //CRUD
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: request)
        
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
