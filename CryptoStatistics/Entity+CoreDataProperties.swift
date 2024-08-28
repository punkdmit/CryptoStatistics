//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Dmitry Apenko on 19.08.2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "CoinEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var percents: Double
    @NSManaged public var usdValue: Double

}
