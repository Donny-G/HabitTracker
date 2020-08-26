//
//  StatsView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])var habits: FetchedResults<Habit>
 
    func imageFromCoreData(habit: Habit) -> UIImage {
        var imageToLoad = UIImage(named: "12")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(named: "12") as! UIImage
    }
    
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(habits, id: \.id) {
                    
                    
                    habit in
                    
                    VStack {
                        BarView(value: CGFloat(habit.percentCompletion))
                        if habit.typeOfAction != 12 {
                            Image("\(habit.typeOfAction)")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .scaledToFit()
                                .shadow(color: .black, radius: 1, x: 5, y: 5)
                        } else {
                            Image(uiImage: self.imageFromCoreData(habit: habit))
                                .resizable()
                                .frame(width: 80, height: 80)
                                .scaledToFit()
                        }
                        Text(habit.wrappedName)
                    }
                }
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
