//
//  StatsView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80)
            .scaledToFit()
            .shadow(color: .black, radius: 1, x: 3, y: 3)
    }
}

struct StatsView: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])var habits: FetchedResults<Habit>
    @Environment(\.colorScheme) var colorScheme
    func imageFromCoreData(habit: Habit) -> UIImage {
        var imageToLoad = UIImage(named: "12")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(named: "12")!
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(habits, id: \.id) {
                            habit in
                            VStack {
                                BarView(value: CGFloat(habit.percentCompletion))
                                if habit.typeOfAction != 12 {
                                    Image("\(habit.typeOfAction)")
                                        .resizable()
                                        .modifier(ImageModifier())
                                } else {
                                    Image(uiImage: self.imageFromCoreData(habit: habit))
                                        .resizable()
                                        .cornerRadius(20)
                                        .modifier(ImageModifier())
                                }
                                Text(habit.wrappedName)
                                    .font(.system(size: 20, weight: .black, design: .rounded))
                                    .foregroundColor(self.colorScheme == .light ? firstTextColorLight : firstTextColorDark)
                                   
                            }
                        }
                    }
                }
            }.navigationBarTitle("Progress", displayMode: .inline)
        }
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
