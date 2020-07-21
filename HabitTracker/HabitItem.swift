//
//  HabitItem.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

struct HabitItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var goal: Int
    var steps = 0
    var  typeOfAction: Int
    
    var percentCompletion: String {
        var text = "%"
        if goal != nil && steps != 0 {
        let percent = (100 * steps) / goal
        
        text = "\(percent) %"
        }
        return text
    }
    
    
}
