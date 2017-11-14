//
//  MasterViewController.swift
//  My_Notes
//
//  Created by Nitin Panchal on 2017-10-31.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//

import UIKit

var objects:[String] = [String]()
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let kNotes:String = "notes"
let blank_note:String = "(New Note)"

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        load() 
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        save()
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if objects.count == 0{
            insertNewObject(self)
        }
        
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        
        if detailViewController?.detailDescriptionTextView.isEditable==false{
            return
        }
        else{
        if objects.count == 0 || objects[0] != blank_note {
            objects.insert(blank_note, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    
        currentIndex = 0
        self.performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //detailViewController?.detailDescriptionTextView.isEditable = true
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                currentIndex = indexPath.row
            }
            let object = objects[currentIndex]
            detailViewController?.detailItem = object as AnyObject
            detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            insertNewObject(self)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            detailViewController?.detailDescriptionTextView.isEditable = false
            detailViewController?.detailDescriptionTextView.text = ""
            
            return
        }
        
        save()
    }
     
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        detailViewController?.detailDescriptionTextView.isEditable = false
        detailViewController?.detailDescriptionTextView.text = ""
        
        save()
    }
    
    func save()
    {
        UserDefaults.standard.set(objects, forKey: kNotes)
        UserDefaults.standard.synchronize ()
    }
    
    func load()
    {
        if let loadedData = UserDefaults.standard.array(forKey: kNotes) as? [String]{
            objects = loadedData
        }
    }
    
    
}

