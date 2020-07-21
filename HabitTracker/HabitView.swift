//
//  HabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

import UIKit

struct HabitView: View {
    @State private var habitName = ""
    @State private var habitGoal = 0
    @State private var habitDescription = ""
    @State private var habitType = 0
    @ObservedObject var habits: Habits
    @State private var goalExamples = [1, 5, 10, 15, 20, 50, 100]
    
    @Environment (\.presentationMode) var presentationMode
    
    var validData: Bool {
        if habitGoal == 0{
            return false
        }
        return true
    }
  
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.942, green: 0.993, blue: 0.716)
                .edgesIgnoringSafeArea(.all)
            Form {
                Section(header: Text("Habit name")){
                TextField("Enter your habit name, please", text: $habitName)
                .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                .foregroundColor(.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 1, x: 5, y: 5)
                }
                
                Section(header: Text("Goal settings")) {
                Stepper("Set your goal for habit \(habitGoal)", value: $habitGoal, in: 1...100)
                .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundColor(.purple)
                    .accentColor(.purple)
                
                Picker("Goal", selection: $habitGoal) {
                    ForEach(goalExamples, id: \.self) {
                        Text(String($0))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .colorMultiply(.orange)
                .background(Color.purple)
                .cornerRadius(5)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
                }
                
                Section(header: Text("Habit description")) {
                TextField("Enter your habit description", text: $habitDescription)
                    .disabled(validData == false)
                    .font(.system(size: 20, weight: Font.Weight.bold, design: Font.Design.rounded))
                        .foregroundColor(.gray)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(5)
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                }
                
                Section(header: Text("Type of action")) {
                //  UIImagePickerController() возможность выбора объекта
                Picker("Choose type of action", selection: $habitType) {
                    ForEach(0..<11) {
                        
                    //    VStack {
                     //   Text("Action is \($0)")
                            Image("\($0)")
                        .resizable()
                                .frame(width: 50, height: 50)
                        .scaledToFit()
                                
                        
                    }
                }.disabled(validData == false)
                .pickerStyle(SegmentedPickerStyle())
                    
                    .cornerRadius(5)
                    .shadow(color: .black, radius: 1, x: 5, y: 5)
                  
                   
                Image("\(habitType)")
                                       .resizable()
                                       .scaledToFit()
                        
                    .frame(width: 250, height: 250, alignment: .center)
                     .shadow(color: .black, radius: 1, x: 5, y: 5)
                   
                }
                }
            }
            .navigationBarTitle("New habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Save habit"){
                let newHabit = HabitItem(name: self.habitName, description: self.habitDescription, goal: self.habitGoal, typeOfAction: self.habitType)
                self.habits.habitItems.insert(newHabit, at: 0)
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView(habits: Habits())
    }
}

