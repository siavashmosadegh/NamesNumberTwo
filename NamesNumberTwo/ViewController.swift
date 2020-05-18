//
//  ViewController.swift
//  NamesNumberTwo
//
//  Created by Siavash Mosadegh on 5/17/20.
//  Copyright © 2020 Siavash Mosadegh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var itemArray = [Item]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadItems()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //print("dorost kar mikone")
        
        let newItem = Item(context: self.context)
        
        newItem.title = textfield.text!
        
        textfield.text = ""
        
        newItem.done = false
        
        self.itemArray.append(newItem)
        
        saveItems()
    }
    
    func saveItems () {
        
        do {
            try context.save()
        } catch {
            print("error dad dige , chikar konam ?")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest <Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data form context \(error)")
        }
        
        tableView.reloadData()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //tableView.deselectRow(at: indexPath, animated: true)
        
        context.delete(itemArray[indexPath.row])
        
        itemArray.remove(at: indexPath.row)
        
        saveItems()
    }
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest <Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS [cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
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



