//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Anastasiia Solomka on 25.08.2023.
//
//

import Foundation
import CoreData


extension CachedFriend {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var user: CachedUser?
    
    var wrappedName: String {
        name ?? "Unknown name"
    }
    
}

extension CachedFriend : Identifiable {
    
}
