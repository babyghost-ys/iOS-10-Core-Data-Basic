//
//  ViewController.swift
//  iOS 10 Core Data
//
//  Created by Peter Leung on 16/11/2016.
//  Copyright © 2016 winandmac Media. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var fetchResultController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchResultController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexpath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexpath: NSIndexPath){
        let item = fetchResultController.object(at: indexpath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = fetchResultController.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailVC" {
            if let destination = segue.destination as? ItemDetailVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch(){
        let fetchRequestofType: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequestofType.sortDescriptors = [dateSort]
            break
        case 1:
            fetchRequestofType.sortDescriptors = [priceSort]
            break
        case 2:
            fetchRequestofType.sortDescriptors = [titleSort]
            break
        default:
            fetchRequestofType.sortDescriptors = [dateSort]
            break
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequestofType, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.fetchResultController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexpath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    func generateTestData(){
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1000
        item.details = "No money"
        
        let item2 = Item(context: context)
        item2.title = "MacBook Pro2"
        item2.price = 1000
        item2.details = "No money2"
        
        AppD.saveContext()
    }
}

