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
    @State private var habitGoal: Int16 = 0
    @State private var habitDescription = ""
    @State private var habitType = 11
    
    //Image Picker
    @State private var selectedImage: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var selectedImageId: UUID?
    @State private var source = 0
    func loadSelectedImage() {
        guard let inputImage = inputImage else { return }
       selectedImage = Image(uiImage: inputImage)
        habitType = 11
    }
    
    //Core Data
    @Environment(\.managedObjectContext) var moc
    @State private var goalExamples: [Int16] = [1, 5, 10, 15, 20, 50, 100]
    
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
                    
                    //Image Picker
                    HStack {
                        Button(action: {
                            self.showingImagePicker = true
                            self.source = 0
                        }) { Image(systemName: "camera")
                        }
                        Button(action: {
                            self.showingImagePicker = true
                            self.source = 1
                        }) { Image(systemName: "photo")
                        }
                    }
                    
                    //Image Picker
                    if selectedImage == nil || habitType != 11 {
                        Image("\(habitType)")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 250, height: 250, alignment: .center)
                                       .shadow(color: .black, radius: 1, x: 5, y: 5)
                    } else if selectedImage != nil {
                        selectedImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250, alignment: .center)
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                        .cornerRadius(20)
                    }
                   
                }
                }
            }
            .navigationBarTitle("New habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Save habit"){
                //Core Data
                let newHabit = Habit(context: self.moc)
                newHabit.name = self.habitName
                newHabit.descr = self.habitDescription
                newHabit.goal = self.habitGoal
                newHabit.typeOfAction = Int16(self.habitType)
            
                if self.moc.hasChanges {
                try? self.moc.save()
                }
                
                self.presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadSelectedImage) {
                ImagePicker(image: self.$inputImage, typeOfSource: self.$source)
            }
        }
    
    }
}



