//
//  Reservation+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var movieId: Int32
    @NSManaged public var movieName: String?
    @NSManaged public var posterImagePath: String?
    @NSManaged public var screeningDate: Date?
    @NSManaged public var user: Account?

}

extension Reservation : Identifiable {

}
