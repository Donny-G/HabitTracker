//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 22.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var descr: String?
    public var wrappedDescr: String {
        descr ?? ""
    }
    
    @NSManaged public var goal: Int16
    public var wrappedGoal: Int16 {
        goal ?? 0
    }
    
    @NSManaged public var id: UUID?
    
    @NSManaged public var img: Data?
    
    @NSManaged public var name: String?
    public var wrappedName: String {
        name ?? ""
    }
    
    @NSManaged public var percentCompletion: String?
    public var wrappedPercentCompletion: String {
        percentCompletion ?? ""
    }

    @NSManaged public var steps: Int16
    public var wrappedSteps: Int16 {
        steps ?? 0
    }
    
    @NSManaged public var typeOfAction: Int16
   

}
