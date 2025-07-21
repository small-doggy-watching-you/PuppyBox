//
//  WatchedMovie+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import Foundation
import CoreData


extension WatchedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchedMovie> {
        return NSFetchRequest<WatchedMovie>(entityName: "WatchedMovie")
    }

    @NSManaged public var movieId: Date?
    @NSManaged public var movieName: String?
    @NSManaged public var posterImagePath: String?
    @NSManaged public var screeningDate: Float
    @NSManaged public var owner: Account?

}

extension WatchedMovie : Identifiable {

}
