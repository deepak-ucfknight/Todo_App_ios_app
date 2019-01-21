//
//  CategoryViewController.swift
//  todoey
//
//  Created by Deepak Balaji on 1/21/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Categories>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    @IBOutlet weak var mainSearchBarOutlet: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
        loadItems()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let navbarColor = FlatRed().lighten(byPercentage: CGFloat(0.5)) {
        
            navigationController?.navigationBar.barTintColor = navbarColor
            
            navigationController?.navigationBar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
            
             navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
            
            mainSearchBarOutlet.barTintColor = navbarColor
            
        }
    }

    
    @IBAction func addbarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
         let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil || textField.text != "" {
                
                let newitem = Categories()
                
                newitem.name = textField.text!
                
                newitem.cellColorCode = UIColor.randomFlat.hexValue()
                
                self.saveData(category: newitem)
    
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
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor =  UIColor(hexString: categories?[indexPath.row].cellColorCode ?? UIColor.white.hexValue())
        
         cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
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
                
                destinationVC.selectedCategory = self.categories?[indexPath.row]
            }
            
           
        }
        
       
    }
    
    //CRUD
    
    func saveData(category: Categories) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
    
        categories = realm.objects(Categories.self)

        tableView.reloadData()
    }
    
    override func deleteActionHandler(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                
            }
        }
    }
    
    
}

//Search bar Feature
extension CategoryViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
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

