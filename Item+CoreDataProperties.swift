//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Denis Kurochkin on 03/10/2016.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var itemID: Int32
    @NSManaged public var itemCode: String?
    @NSManaged public var groupID: Int32
    @NSManaged public var subgroupID: Int32
    @NSManaged public var trademarkID: Int32
    @NSManaged public var color: String?
    @NSManaged public var certificationType: String?
    @NSManaged public var certificationAuthorittyCode: String?
    @NSManaged public var itemCode_2: String?
    @NSManaged public var line1: String?
    @NSManaged public var line2: String?
    @NSManaged public var storeNumber: String?
    @NSManaged public var name: String?
    @NSManaged public var priceHeader: String?
    @NSManaged public var sizeHeader: String?
    @NSManaged public var size: String?
    @NSManaged public var additionalSize: String?
    @NSManaged public var additionalInfo: String?
    @NSManaged public var boxType: String?
    @NSManaged public var barcode: String?

}
