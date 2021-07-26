//
//  Query+CoreDataProperties.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 23.07.2021.
//
//

import Foundation
import CoreData


extension Query {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Query> {
        return NSFetchRequest<Query>(entityName: "Query")
    }

    @NSManaged public var queryText: String?
    @NSManaged public var queryToRes: NSSet?

}

// MARK: Generated accessors for queryToRes
extension Query {

    @objc(addQueryToResObject:)
    @NSManaged public func addToQueryToRes(_ value: Repositories)

    @objc(removeQueryToResObject:)
    @NSManaged public func removeFromQueryToRes(_ value: Repositories)

    @objc(addQueryToRes:)
    @NSManaged public func addToQueryToRes(_ values: NSSet)

    @objc(removeQueryToRes:)
    @NSManaged public func removeFromQueryToRes(_ values: NSSet)

}

extension Query : Identifiable {

}
