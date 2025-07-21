//
//  WatchedMovie+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import CoreData
import Foundation

public extension WatchedMovie {
    @nonobjc class func fetchRequest() -> NSFetchRequest<WatchedMovie> {
        return NSFetchRequest<WatchedMovie>(entityName: "WatchedMovie")
    }

    @NSManaged var movieId: Int32
    @NSManaged var movieName: String
    @NSManaged var posterImagePath: String?
    @NSManaged var screeningDate: Date
    @NSManaged var owner: Account?
}

extension WatchedMovie: Identifiable {}
