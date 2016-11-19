//
//  ItemDetailVC.swift
//  iOS 10 Core Data
//
//  Created by Peter Leung on 18/11/2016.
//  Copyright © 2016 winandmac Media. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfDetails: UITextField!
    
    var storesArray = [Store]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesco"
//        let store3 = Store(context: context)
//        store3.name = "Curry PC"
//        let store4 = Store(context: context)
//        store4.name = "K Mart"
//        
//        AppD.saveContext()
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = storesArray[row]
        return store.name
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storesArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item = Item!
        if itemToEdit = nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        guard let title = tfTitle.text, let price = tfPrice.text, let details = tfDetails.text else{
            return
        }
        item.title = title
        item.price = (price as NSString).doubleValue
        item.details = details
        
        item.toStore = storesArray[storePicker.selectedRow(inComponent: 0)]
        
        AppD.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.storesArray = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //error
        }
    }
    
    func loadItemData(){
        if let item = itemToEdit {
            tfTitle.text = item.title
            tfPrice.text = "\(item.price)"
            tfDetails.text = item.details
            
            if let store = item.toStore {
                var index = 0
                
                repeat{
                    let s = storesArray[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < storesArray.count)
            }
        }
    }
}
