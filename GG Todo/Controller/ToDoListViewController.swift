//
//  ViewController.swift
//  GG Todo
//
//  Created by Abel Xu on 11/9/18.
//  Copyright © 2018 Yupeng Xu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController, UISearchBarDelegate {
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
   
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedCategory?.name
        
        searchBar.delegate = self
        
        tableView.rowHeight = 60.0

        
    }


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if item.done == true {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        else {
            cell.textLabel?.text = "No items added"
        }
        
        
        cell.backgroundColor = UIColor(hexString: selectedCategory?.color ?? "EB5437")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: selectedCategory?.color ?? "EB5437")!, returnFlat: true)
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status \(error)")
            }
        }

        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todo Item", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
            //print(alertTextField.text)
        }
        
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            if textField.text == ""
            {
                print("Please create a new item")
            }
            else {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch {
                        print("Error saving new items, \(error)")
                    }
                    self.tableView.reloadData()
                }
            }
            
            
        
            
        }))
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func loadItems() {
       
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error deleting cell \(error)")
            }
            //self.tableView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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

