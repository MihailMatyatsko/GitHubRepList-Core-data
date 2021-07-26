//
//  Repositories+CoreDataProperties.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 23.07.2021.
//
//

import Foundation
import CoreData


extension Repositories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repositories> {
        return NSFetchRequest<Repositories>(entityName: "Repositories")
    }

    @NSManaged public var iD: Int64
    @NSManaged public var fullName: String?
    @NSManaged public var reposDescrip: String?
    @NSManaged public var watchers: Int64
    @NSManaged public var htmlURL: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var query: Query?

}

extension Repositories : Identifiable {

}
