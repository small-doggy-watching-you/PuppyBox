//
//  Account+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/16/25.
//
//

import CoreData
import Foundation

public extension Account {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged var id: UUID
    @NSManaged var password: String
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var profile: String?
    @NSManaged var name: String
    @NSManaged var userId: String
    @NSManaged var isAdmin: Bool
}

extension Account: Identifiable {}
