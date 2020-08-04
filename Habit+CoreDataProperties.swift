//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 03.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    
    @NSManaged public var typeOfManualNotification: String?
    public var wrappedTypeOfManualNotification: String {
        typeOfManualNotification ?? ""
    }
    
    @NSManaged public var delayInMinutes: String?
    public var wrappedDelayInMinutes: String {
        delayInMinutes ?? ""
    }
    
    @NSManaged public var delayInHours: String?
    public var wrappedDelayInHours: String {
        delayInHours ?? ""
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
       
    @NSManaged public var percentCompletion: Float
       
    @NSManaged public var steps: Int16
       public var wrappedSteps: Int16 {
           steps ?? 0
       }
       
    @NSManaged public var typeOfAction: Int16
       
    @NSManaged public var ntfnEnabled: Bool
       
    @NSManaged public var typeOfNtfn: String?
       public var wrappedTypeOfNtfn: String {
           typeOfNtfn ?? ""
       }
       
    @NSManaged public var timeForNtfn: String?
       public var wrappedTimeForNtfn: String {
           timeForNtfn ?? ""
       }
       
    @NSManaged public var daysForNtfn: String?
       public var wrappedDaysForNtfn: String {
           daysForNtfn ?? ""
       }
       
    @NSManaged public var isNtfnContinues: Bool
       
    @NSManaged public var idForNtfn: String?

}
