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
    @State private var notificationIsEnabled = false
    var id = UUID().uuidString
    @State private var isDefaultNotificationEnabled = false
    @State private var isManualNotificationEnabled = false
    
    @State private var time = Date()
     
    @State private var title = ""
    @State private var subtitle = ""
     
    @State private var typeOfNotification = 0
    let typesOfNotifications = ["Time delay", "Time + days"]
     
    @State private var delayInMinutes = ""
    @State private var delayInHours = ""
    @State private var typeOfDelay = 0
    let typesOfDelay = ["Minutes", "Hours"]
     
    @State private var isContinues = false
    @State private var showDaysOfTheWeek = false
    
    @State private var selectedButtonsArray = [Int]()
    let weekDaysArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    @State private var daysNotifyArray = [Int]()
    @State private var selectedDaysArray = [String]()

    func hourFromPicker()->Int {
         let components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: time)
         return components.hour ?? 9
    }
        
    func minuteFromPicker()->Int {
         let components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: time)
         return components.minute ?? 0
    }
     
    func setManualNotification(title: String?, subtitle: String?) {
         
        let content = UNMutableNotificationContent()
        if title == "" {
        content.title = title ?? habitName
        }
        content.subtitle = subtitle ?? "Right now"
        content.sound = UNNotificationSound.default
        
        let imageName = "logo"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return }
        let attachment  = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]
         
        switch typeOfNotification {
        case 0:
            //interval delay
            if typeOfDelay == 0 {
                guard let tempInterval = Double(delayInMinutes) else { return }
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempInterval * 60, repeats: isContinues)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            } else {
                guard let tempInterval = Double(delayInHours) else { return }
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempInterval * 3600, repeats: isContinues)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
             
        case 1:
            //everyday time
            if showDaysOfTheWeek == false {
                var dateComponents = DateComponents()
                dateComponents.hour = hourFromPicker()
                dateComponents.minute = minuteFromPicker()
            
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isContinues)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
                UNUserNotificationCenter.current().add(request)
            } else {
                if !daysNotifyArray.isEmpty {
                    for day in daysNotifyArray {
                        var dateComponents = DateComponents()
                        dateComponents.weekday = day
                        dateComponents.hour = hourFromPicker()
                        dateComponents.minute = minuteFromPicker()
                        dateComponents.timeZone = .current
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isContinues)
                        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                    }
                } else {
                    print("choose days please")
                }
            }
             
        default:
            print("Unknown type")
        }
    
        //test for delete notifications
       // notificationsIDArray.append(id)
       
        daysNotifyArray = []
        selectedButtonsArray = []
         
    }
     
    //local notifications
    func setDefaultNotification(title: String?, subtitle: String?) {
        guard notificationIsEnabled == true else { return }
        let content = UNMutableNotificationContent()
        content.title = habitName
        content.subtitle = "Do it right now"
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
    func deleteLocalNotification(identifier: String) {
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
                    .onAppear(perform: startNotification)
                if notificationIsEnabled {
                    HStack {
                        
                        Button(action: {
                            if self.isDefaultNotificationEnabled == false && self.isManualNotificationEnabled == false {
                                self.setDefaultNotification(title: self.habitName, subtitle: nil)
                                self.isDefaultNotificationEnabled = true
                            } else {
                                self.deleteLocalNotification(identifier: self.id)
                                self.isDefaultNotificationEnabled = false
                            }
                        }) {
                            Text("Set default notification at 9:00 everyday")
                        }
                            .background(isDefaultNotificationEnabled ? Color.red : Color.white)
                            
                    
                        Button(action: {
                            if self.isManualNotificationEnabled == false && self.isDefaultNotificationEnabled == false {
                                self.isManualNotificationEnabled = true
                            } else {
                                self.deleteLocalNotification(identifier: self.id)
                                self.isManualNotificationEnabled = false
                            }
                        }) {
                        Text("Set manual notification")
                        }
                            .background(isManualNotificationEnabled ? Color.red : Color.white)
                    }
                        .buttonStyle(BorderlessButtonStyle())
                    
                    if isManualNotificationEnabled {
                        VStack {
                            Form {
                                TextField("Enter title", text: $title)
                                TextField("Enter subtitle", text: $subtitle)
                                
                                Picker("Notification type", selection: $typeOfNotification) {
                                    ForEach(0..<typesOfNotifications.count) {
                                        Text(self.typesOfNotifications[$0])
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                
                    if typeOfNotification == 0 {
                        Picker("Choose type of delay", selection: $typeOfDelay) {
                            ForEach(0..<typesOfDelay.count) {
                                Text(self.typesOfDelay[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                                    
                    if typeOfDelay == 0 {
                        TextField("Enter minutes for notification", text: $delayInMinutes)
                            .keyboardType(.numberPad)
                    } else {
                        TextField("Enter hours for notification", text: $delayInHours)
                            .keyboardType(.numberPad)
                    }
                                    
                        Toggle("Is continues", isOn: $isContinues)
                        
                    } else if typeOfNotification == 1 {
                        
                        DatePicker("select time", selection: $time, displayedComponents: .hourAndMinute)
                        Toggle("Is continues", isOn: $isContinues)
                        Toggle("Days of the week", isOn: $showDaysOfTheWeek)
                        if showDaysOfTheWeek {
                            HStack {
                                ForEach(0..<weekDaysArray.count, id: \.self) { day in
                                    Button(action: {
                                        if let index = self.selectedButtonsArray.firstIndex(of: day) {
                                            self.daysNotifyArray.remove(at: index)
                                            self.selectedButtonsArray.remove(at: index)
                                            self.selectedDaysArray.remove(at: index)
                                            print(self.daysNotifyArray)
                                        } else {
                                            self.daysNotifyArray.append(day + 1)
                                            self.selectedButtonsArray.append(day)
                                            self.selectedDaysArray.append(self.weekDaysArray[day])
                                            print(self.selectedDaysArray)
                                        }
                                    }) {
                                        Text(self.weekDaysArray[day])
                                    }
                                        .buttonStyle(PlainButtonStyle())
                                        .background(self.selectedButtonsArray.contains(day) ? Color.red : Color.blue)
                                }
                            }
                        }
                    }
                            
                        Button(action: {
                            self.setManualNotification(title: self.title, subtitle: self.subtitle)
                        }) {
                            Image(systemName: "plus")
                        }
                            
                                //manage notifications - for delete
                        Button(action: {
                            self.deleteLocalNotification(identifier: self.id)
                        }){
                            Text("Delete notif")
                        }
                    }
                }
                    .frame(height: 500)
            }
                    
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
                    if self.isDefaultNotificationEnabled {
                        newHabit.typeOfNtfn = TypeOfNotifications.def.rawValue
                        newHabit.idForNtfn = self.id
                    } else {
                        if self.isManualNotificationEnabled {
                        
                        newHabit.typeOfNtfn = TypeOfNotifications.manual.rawValue
                        newHabit.idForNtfn = self.id
                        newHabit.isNtfnContinues = self.isContinues
                            
                            if self.typeOfNotification == 0 {
                                newHabit.typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                                        
                                if self.typeOfDelay == 0 {
                                    newHabit.delayInMinutes = "\(self.delayInMinutes) min"
                                    print("\(self.delayInMinutes) min")
                                        } else {
                                    newHabit.delayInHours = "\(self.delayInHours) h"
                                        }
                            } else {
                                    newHabit.typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                                    newHabit.timeForNtfn = "\(self.hourFromPicker()) : \(self.minuteFromPicker())"
                                    if self.showDaysOfTheWeek {
                                        newHabit.daysForNtfn = self.selectedDaysArray.joined(separator: ", ")
                                    }
                                
                                }
                            }
                            
                            
                        }
                    }
                
            
                if self.moc.hasChanges {
                try? self.moc.save()
                }
                self.selectedDaysArray = []
                
                self.presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadSelectedImage) {
                ImagePicker(image: self.$inputImage, typeOfSource: self.$source)
            }
            
        }
    
    }
}



