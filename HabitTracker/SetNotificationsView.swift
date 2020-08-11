//
//  SetNotificationsView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 04.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct SetNotificationsView: View {
    @Binding var id: String
    @Binding  var isDefaultNotificationEnabled: Bool
    @Binding  var isManualNotificationEnabled:Bool
    @Binding var habitName: String
    @Binding var typeOfNotification: Int
    @Binding var delayInMinutes: String
    @Binding var delayInHours:String
    @Binding var typeOfDelay: Int
    @Binding var isContinues: Bool
    @Binding var showDaysOfTheWeek: Bool
    @Binding var selectedDaysArray: [String]
    @Binding var hours: Int
    @Binding  var minutes:Int
    
    @State private var time = Date()
    @State private var title = ""
    @State private var subtitle = ""
    @State private var selectedButtonsArray = [Int]()
    @State private var daysNotifyArray = [Int]()
    
    @State private var defaultIsTapped = false
    @State private var manualIsTapped = false
    
    @Environment (\.presentationMode) var presentationMode
        
    let typesOfNotifications = ["Time delay", "Time + days"]
    let typesOfDelay = ["Minutes", "Hours"]
    let weekDaysArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    func hourFromPicker()->Int {
        let components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: time)
        hours = components.hour ?? 9
        return hours
    }
    
    func minuteFromPicker()->Int {
        let components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: time)
        minutes = components.minute ?? 0
        return minutes
    }
    
    func setManualNotification(title: String?, subtitle: String?) {
        let content = UNMutableNotificationContent()
        if title == "" {
            content.title = habitName
        } else {
            content.title = title ?? "Do it"
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
            
            daysNotifyArray = []
            selectedButtonsArray = []
            simpleSuccess()
    }
        
       //local notifications
    func setDefaultNotification(title: String?, subtitle: String?) {
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
        simpleSuccess()
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
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func checking() {
        if delayInMinutes.isEmpty && delayInHours.isEmpty{
            print("empty")
        } else {
            
        }
    }
    
    
    var body: some View {
        Form {
            HStack {
                Button(action: {
                    if self.isDefaultNotificationEnabled == false && self.isManualNotificationEnabled == false {
                        self.setDefaultNotification(title: self.habitName, subtitle: nil)
                        self.isDefaultNotificationEnabled = true
                        self.defaultIsTapped = true
                    } else {
                        self.deleteLocalNotification(identifier: self.id)
                        self.isDefaultNotificationEnabled = false
                        self.defaultIsTapped = false
                    }
                }) {
                    Text("Set default notification at 9:00 everyday")
                }
                    .onAppear(perform: startNotification)
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
            
            if !isDefaultNotificationEnabled && !isManualNotificationEnabled {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                }
            }
            
            if isDefaultNotificationEnabled {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Set and Back")
                }
            }
            
            VStack {
                if isManualNotificationEnabled {
                        Form {
                            TextField("Enter title", text: $title)
                            TextField("Enter subtitle", text: $subtitle)
                            Picker("Notification type", selection: $typeOfNotification) {
                                ForEach(0..<typesOfNotifications.count) {
                                    Text(self.typesOfNotifications[$0])
                                }
                            }   .pickerStyle(SegmentedPickerStyle())
                                       
                            if typeOfNotification == 0 {
                                Picker("Choose type of delay", selection: $typeOfDelay) {
                                    ForEach(0..<typesOfDelay.count) {
                                        Text(self.typesOfDelay[$0])
                                    }
                                }   .pickerStyle(SegmentedPickerStyle())
                                           
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
                                //add alert
                                if self.delayInMinutes.isEmpty && self.delayInHours.isEmpty{
                                    print("empty")
                                } else {
                                    self.setManualNotification(title: self.title, subtitle: self.subtitle)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Image(systemName: "plus")
                            }
                        
                            //check lnf
                            Button(action: {
                                self.checkLocalNotifications()
                            }) {
                                Text("Check")
                            }
                                   
                        //manage notifications - for delete
                            Button(action: {
                                self.deleteLocalNotification(identifier: self.id)
                            }){
                                Text("Delete notif")
                            }
                        }
                        .frame(height: 400)
                }
            }
        }
    }
}


