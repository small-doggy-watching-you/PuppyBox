//
//  Reservation+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import CoreData
import Foundation

public extension Reservation {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged var userId: String
    @NSManaged var movieId: Int32
    @NSManaged var movieName: String
    @NSManaged var posterImagePath: String?
    @NSManaged var screeningDate: Date
    @NSManaged var user: Account?
}

extension Reservation: Identifiable {}
