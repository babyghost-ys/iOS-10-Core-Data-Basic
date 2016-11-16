//
//  ItemType+CoreDataProperties.swift
//  iOS 10 Core Data
//
//  Created by Peter Leung on 16/11/2016.
//  Copyright © 2016 winandmac Media. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
