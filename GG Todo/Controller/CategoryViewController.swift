//
//  CategoryViewController.swift
//  GG Todo
//
//  Created by Abel Xu on 11/9/18.
//  Copyright © 2018 Yupeng Xu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Firebase

class CategoryViewController: SwipeTableViewController {

   
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "d82929")
        
        loadCategories()

        tableView.rowHeight = 80.0
       
        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categroy added yet"
        if let category = categories?[indexPath.row] {
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
        }
        
      
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    
    func saveCategories(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch {
                print("Error deleting cell \(error)")
            }
            //self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add category", style: .default, handler: { (action) in
            if textField.text == ""
            {
                print("Please create a new category")
            }
            else {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                
                self.saveCategories(newCategory)
            }
            
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func logOut(action: UIAlertAction) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
    
    
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure to log out?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: logOut))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
 
}
