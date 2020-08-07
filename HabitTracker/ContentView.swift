//
//  ContentView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        var body: some View {
            TabView {
                MainHabitView(predicateType: .active)
                    .tabItem {
                        Image(systemName: "star")
                        Text("Active")
                }
                
                MainHabitView(predicateType: .completed)
                    .tabItem {
                        Image(systemName: "triangle")
                        Text("Completed")
                }
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
