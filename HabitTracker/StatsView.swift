//
//  StatsView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageModifier: ViewModifier {
    var geo: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: geo, height: geo)
            .scaledToFit()
            .shadow(color: .black, radius: 1, x: 3, y: 3)
    }
}

struct StatsView: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [])var habits: FetchedResults<Habit>
    @Environment(\.colorScheme) var colorScheme
    func imageFromCoreData(habit: Habit) -> UIImage {
        var imageToLoad = UIImage(named: "14")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(named: "14")!
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                GeometryReader { geo in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.habits, id: \.id) {
                                habit in
                                VStack {
                                    BarView(value: CGFloat(habit.percentCompletion), height: geo.size.height * 0.45)
                                    if habit.typeOfAction != 14 {
                                        Image("\(habit.typeOfAction)")
                                            .resizable()
                                            .modifier(ImageModifier(geo: geo.size.width * 0.2))
                                    } else {
                                        Image(uiImage: self.imageFromCoreData(habit: habit))
                                            .resizable()
                                            .cornerRadius(20)
                                            .modifier(ImageModifier(geo: geo.size.width * 0.2))
                                    }
                                    Text(habit.wrappedName)
                                        .font(.system(size: 20, weight: .black, design: .rounded))
                                        .foregroundColor(self.colorScheme == .light ? firstTextColorLight : firstTextColorDark)
                                        .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.2)
                                }
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
