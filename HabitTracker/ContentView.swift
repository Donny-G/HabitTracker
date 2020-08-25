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
                        Image("active5")
                        Text("Active")
                }
                
                MainHabitView(predicateType: .completed)
                    .tabItem {
                        Image("completed2")
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
