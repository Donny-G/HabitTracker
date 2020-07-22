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
    
        //Core Data
        @Environment(\.managedObjectContext) var moc
        @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)]) var habits: FetchedResults<Habit>
    
        @State private var habitViewOpen = false
        @Environment(\.presentationMode) var presentationMode
        
        //Core Data
        func removeHabits(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            moc.delete(habit)
        }
            try? moc.save()
        }
    
    
        
        var body: some View {
            NavigationView {
                ZStack {
                    Color(red: 0.942, green: 0.993, blue: 0.716)
                        .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(habits, id: \.id) {
                        
                        habit in
               // Core Data
                        NavigationLink(destination: DetailHabitView(habit: habit)) {
                            
                            HStack(alignment: .center, spacing: 20) {
                                //Core Data
                                Text(habit.wrappedName)
                            .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                            .foregroundColor(.orange)
                            
                                VStack(alignment: .leading, spacing: 5) {
                                    //Core Data
                                    Text("Goal: \(habit.wrappedGoal)")
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundColor(.purple)
                            //Core Data
                            Text("Streaks: \(habit.wrappedSteps)")
                                .font(.system(size: 17, weight: Font.Weight.black, design: Font.Design.rounded))
                                .foregroundColor(.gray)
                                    //Core Data
                                    Text("Progress: \(habit.wrappedPercentCompletion)")
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundColor(Color.init(red: 1, green: 0.247, blue: 0.357))
                            
                        }   //Core Data
                            Image("\(habit.typeOfAction)")
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
                                                                                    //Core Data
                }) .sheet(isPresented: $habitViewOpen) { HabitView().environment(\.managedObjectContext, self.moc)
                }
                
            }
            
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
