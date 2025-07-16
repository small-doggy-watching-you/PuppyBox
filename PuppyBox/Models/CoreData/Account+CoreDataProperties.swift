//
//  Account+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/16/25.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: UUID
    @NSManaged public var password: String
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var profile: String?
    @NSManaged public var name: String
    @NSManaged public var userId: String

}

extension Account : Identifiable {

}
