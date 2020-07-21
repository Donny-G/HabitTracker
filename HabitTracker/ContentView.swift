//
//  ContentView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    init() {
            UITableView.appearance().backgroundColor = .clear // tableview background
            UITableViewCell.appearance().backgroundColor = .clear // cell background
        }
        
        @ObservedObject var habits = Habits()
        @State private var habitViewOpen = false
        @Environment(\.presentationMode) var presentationMode
        
        func removeHabits(at offsets: IndexSet) {
            habits.habitItems.remove(atOffsets: offsets)
        }
        
        var body: some View {
            NavigationView {
                ZStack {
                    Color(red: 0.942, green: 0.993, blue: 0.716)
                        .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(habits.habitItems) {
                        
                        item in
               //
                        NavigationLink(destination: DetailHabitView(habit: item, habits: self.habits)) {
                            
                            HStack(alignment: .center, spacing: 20) {
                        Text(item.name)
                            .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                            .foregroundColor(.orange)
                            
                                VStack(alignment: .leading, spacing: 5) {
                            Text("Goal: \(item.goal)")
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundColor(.purple)
                            
                            Text("Streaks: \(item.steps)")
                                .font(.system(size: 17, weight: Font.Weight.black, design: Font.Design.rounded))
                                .foregroundColor(.gray)
                                
                            Text("Progress: \(item.percentCompletion)")
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundColor(Color.init(red: 1, green: 0.247, blue: 0.357))
                            
                        }
                            Image("\(item.typeOfAction)")
                            .resizable()
                            .frame(width: 80, height: 80)
                                .scaledToFit()
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                            
                    }
                            
                  //окончание navlink
                        
                    }
                    }.onDelete(perform: removeHabits)
                    
                }
                }
                
                .navigationBarTitle("Habit tracker", displayMode: .inline)
                .navigationBarItems(leading:
                        HStack {
                        EditButton()
                        }, trailing: HStack {
                            Button(action: {
                                self.habitViewOpen.toggle()
                            }) {
                                Image(systemName: "plus")
                                    }
                            
                }) .sheet(isPresented: $habitViewOpen) { HabitView(habits: self.habits)
                }
                
            }
            
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
