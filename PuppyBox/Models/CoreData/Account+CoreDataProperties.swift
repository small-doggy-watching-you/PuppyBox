//
//  Account+CoreDataProperties.swift
//  PuppyBox
//
//  Created by Yoon on 7/21/25.
//
//

import CoreData
import Foundation

public extension Account {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged var id: UUID
    @NSManaged var userId: String
    @NSManaged var password: String
    @NSManaged var name: String
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var profile: String?
    @NSManaged var isAdmin: Bool
    @NSManaged var watchedMovies: NSSet?
    @NSManaged var reservation: NSSet?
}

// MARK: Generated accessors for watchedMovies

public extension Account {
    @objc(addWatchedMoviesObject:)
    @NSManaged func addToWatchedMovies(_ value: WatchedMovie)

    @objc(removeWatchedMoviesObject:)
    @NSManaged func removeFromWatchedMovies(_ value: WatchedMovie)

    @objc(addWatchedMovies:)
    @NSManaged func addToWatchedMovies(_ values: NSSet)

    @objc(removeWatchedMovies:)
    @NSManaged func removeFromWatchedMovies(_ values: NSSet)
}

// MARK: Generated accessors for reservation

public extension Account {
    @objc(addReservationObject:)
    @NSManaged func addToReservation(_ value: Reservation)

    @objc(removeReservationObject:)
    @NSManaged func removeFromReservation(_ value: Reservation)

    @objc(addReservation:)
    @NSManaged func addToReservation(_ values: NSSet)

    @objc(removeReservation:)
    @NSManaged func removeFromReservation(_ values: NSSet)
}

extension Account: Identifiable {}
