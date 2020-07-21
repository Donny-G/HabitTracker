//
//  Habits.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

class Habits: ObservableObject {
    @Published var habitItems = [HabitItem]() {
    didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habitItems) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
                print("saved")
            }
        }
    }
    
    
    
    
    
    init() {
        if let habitsSaved = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([HabitItem].self, from: habitsSaved) {
                self.habitItems = decoded
                return
            }
        }
        print("empty")
        self.habitItems = []
    }
    
}
