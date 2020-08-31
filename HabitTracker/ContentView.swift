//
//  ContentView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

   // init() {
    //    UITabBar.appearance().barTintColor = UIColor(named: "tabBarColor")
     //   UITabBar.appearance().unselectedItemTintColor = UIColor(named: "tabBarColor")
     //   UINavigationBar.appearance().barTintColor = UIColor(named: "tabBarColor")
        
      
        //UITabBar.appearance().tintColor = .red
   // }
    
    
        var body: some View {
            TabView {
                MainHabitView(predicateType: .active)
                    .tabItem {
                        Image("active5")
                        Text("Active habits")
                }
                
                MainHabitView(predicateType: .completed)
                    .tabItem {
                        Image("completed2")
                        Text("Completed habits")
                }
                
                StatsView()
                    .tabItem {
                        Image("graph")
                        Text("Statistics")
                }
            }.navigationViewStyle(StackNavigationViewStyle())
             //   .accentColor(colorScheme == .light ? tabBarTextSecondaryLightColor  : tabBarTextSecondaryDarkColor)
             //   .foregroundColor(.red)
            
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
