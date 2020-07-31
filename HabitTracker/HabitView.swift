//
//  HabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

import UIKit

import UserNotifications

struct HabitView: View {
    @State private var habitName = ""
    @State private var habitGoal: Int16 = 0
    @State private var habitDescription = ""
    @State private var habitType = 11
    
    //Image Picker
    @State private var selectedImage: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var source = 0
    func loadSelectedImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = Image(uiImage: inputImage)
        habitType = 11
    }
    
    //local notifications
    @State private var notificationIsEnabled = false
    var id = UUID().uuidString
    @State private var isDefaultNotificationEnabled = false
    @State private var isManualNotificationEnabled = false
    
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
    
    //local notifications
    func setDefaultNotification(title: String?, subtitle: String?) {
        guard notificationIsEnabled == true else { return }
        let content = UNMutableNotificationContent()
        content.title = title ?? "Do it"
        content.subtitle = subtitle ?? "Right now"
        content.sound = UNNotificationSound.default
        
        //logo for notification
        let imageName = "logo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return }
        let attachment  = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
    
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //local notifications
    func startNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //local notifications
    func deleteDefaultLocalNotification(identifier: String) {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    //check lnf
    func checkLocalNotifications() {
        let notifcenter = UNUserNotificationCenter.current()
        notifcenter.getPendingNotificationRequests { (notificationRequests) in
            for notificationRequest: UNNotificationRequest in notificationRequests {
                print(notificationRequest.identifier)
            }
        }
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
                
                //local notifications
                Toggle(isOn: $notificationIsEnabled.animation()) {
                    Text("Set notification")
                }
                if notificationIsEnabled {
                    HStack {
                        
                        Button(action: {
                            if self.isDefaultNotificationEnabled == false {
                                self.setDefaultNotification(title: self.habitName, subtitle: nil)
                                self.isDefaultNotificationEnabled = true
                            } else {
                                self.deleteDefaultLocalNotification(identifier: self.id)
                                self.isDefaultNotificationEnabled = false
                            }
                        }) {
                            Text("Set default notification at 9:00 everyday")
                        }
                            .background(isDefaultNotificationEnabled ? Color.red : Color.white)
                            .onAppear(perform: startNotification)
                    
                        Button(action: {
                            //
                        }) {
                        Text("Set manual notification")
                        }
                    }
                        .buttonStyle(BorderlessButtonStyle())
                    //check lnf
                    Button(action: {
                        self.checkLocalNotifications()
                    }) {
                        Text("Check")
                    }
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
                newHabit.id = UUID()
                newHabit.name = self.habitName
                newHabit.descr = self.habitDescription
                newHabit.goal = self.habitGoal
                newHabit.typeOfAction = Int16(self.habitType)
                //Image Picker + Core Data
                newHabit.img = self.inputImage?.jpegData(compressionQuality: 1.0)
                
                //ntfn
                if self.notificationIsEnabled {
                    newHabit.ntfnEnabled = true
                    newHabit.typeOfNtfn = "Default"
                    newHabit.idForNtfn = self.id
                }
            
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



