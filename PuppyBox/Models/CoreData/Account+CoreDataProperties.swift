//
//  Account+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var userId: String
    @NSManaged public var password: String
    @NSManaged public var name: String
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var profile: String?
    @NSManaged public var isAdmin: Bool
    @NSManaged public var watchedMovies: NSSet?
    @NSManaged public var reservation: NSSet?

}

// MARK: Generated accessors for watchedMovies
extension Account {

    @objc(addWatchedMoviesObject:)
    @NSManaged public func addToWatchedMovies(_ value: WatchedMovie)

    @objc(removeWatchedMoviesObject:)
    @NSManaged public func removeFromWatchedMovies(_ value: WatchedMovie)

    @objc(addWatchedMovies:)
    @NSManaged public func addToWatchedMovies(_ values: NSSet)

    @objc(removeWatchedMovies:)
    @NSManaged public func removeFromWatchedMovies(_ values: NSSet)

}

// MARK: Generated accessors for reservation
extension Account {

    @objc(addReservationObject:)
    @NSManaged public func addToReservation(_ value: Reservation)

    @objc(removeReservationObject:)
    @NSManaged public func removeFromReservation(_ value: Reservation)

    @objc(addReservation:)
    @NSManaged public func addToReservation(_ values: NSSet)

    @objc(removeReservation:)
    @NSManaged public func removeFromReservation(_ values: NSSet)

}

extension Account : Identifiable {

}
