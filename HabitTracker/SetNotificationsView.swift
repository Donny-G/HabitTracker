//
//  SetNotificationsView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 04.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
//hide keyboard
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MainTextNotificationViewModifier: ViewModifier {
    var size: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .black, design: .rounded))
    }
}

struct SetNotificationsView: View {
    @Binding var id: String
    @Binding var isDefaultNotificationEnabled: Bool
    @Binding var isManualNotificationEnabled:Bool
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
    @State private var showAlert = false
    @State private var defaultIsTapped = false
    @State private var manualIsTapped = false
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.presentationMode) var presentationMode
        
    let typesOfNotifications = ["Time delay", "Time + days"]
    let typesOfDelay = ["Minutes", "Hours"]
    let weekDaysArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var activatedColor: Color {
        self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor
    }
    
    var deactivatedColor: Color {
        self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
    }
    
    
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

    var body: some View {
        ZStack {
            colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
            GeometryReader { geo in
                Form {
                    VStack(alignment: .leading) {
                        if !self.isDefaultNotificationEnabled && !self.isManualNotificationEnabled {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Back")
                                    .modifier(MainTextNotificationViewModifier(size: 25))
                                    .foregroundColor(self.activatedColor)
                            }
                        }
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
                            Image("auto")
                                .renderingMode(.original)
                                .resizable()
                                .modifier(CurrentImageModifier(width: geo.size.width / 2, height: 200))
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                            Text("Set default notification at 9:00 everyday")
                                .modifier(MainTextNotificationViewModifier(size: 25))
                                .foregroundColor(self.isDefaultNotificationEnabled ?  self.deactivatedColor : self.activatedColor)
                        }
                            .onAppear(perform: self.startNotification)
                            .background(self.isDefaultNotificationEnabled ? self.activatedColor : self.deactivatedColor)
                            .cornerRadius(20)
                                   
                        Button(action: {
                            if self.isManualNotificationEnabled == false && self.isDefaultNotificationEnabled == false {
                                self.isManualNotificationEnabled = true
                            } else {
                                self.deleteLocalNotification(identifier: self.id)
                                self.isManualNotificationEnabled = false
                            }
                        }) {
                            Image("manual")
                                .renderingMode(.original)
                                .resizable()
                                .modifier(CurrentImageModifier(width: geo.size.width / 2, height: 200))
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                            Text("Set manual notification")
                                .modifier(MainTextNotificationViewModifier(size: 25))
                                .foregroundColor(self.isManualNotificationEnabled ?  self.deactivatedColor : self.activatedColor)
                        }
                            .background(self.isManualNotificationEnabled ?  self.activatedColor : self.deactivatedColor)
                            .cornerRadius(20)
                    }
                        .buttonStyle(BorderlessButtonStyle())
            
                    if self.isDefaultNotificationEnabled {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("setNotificationOn")
                                    .renderingMode(.original)
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 200, height: 200))
                                Text("Set and Back")
                                    .modifier(MainTextNotificationViewModifier(size: 25))
                                    .foregroundColor(self.activatedColor)
                            }
                                Spacer()
                        }
                    }
            
                    VStack {
                        if self.isManualNotificationEnabled {
                            VStack( spacing: 20){
                                Spacer()
                                TextField("Enter title", text: self.$title)
                                    .modifier(TextFieldModifier(size: 20))
                                TextField("Enter subtitle", text: self.$subtitle)
                                    .modifier(TextFieldModifier(size: 20))
                                Picker("Notification type", selection: self.$typeOfNotification) {
                                    ForEach(0..<self.typesOfNotifications.count) {
                                        Text(self.typesOfNotifications[$0])
                                    }
                                }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding()
                                    .background(self.colorScheme == .light ? barColorLight : blue)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 1, x: 5, y: 5)
                                       
                                if self.typeOfNotification == 0 {
                                    Picker("Choose type of delay", selection: self.$typeOfDelay) {
                                        ForEach(0..<self.typesOfDelay.count) {
                                            Text(self.typesOfDelay[$0])
                                        }
                                    }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                                        .background(self.colorScheme == .light ? barColorLight : blue)
                                        .cornerRadius(20)
                                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                                           
                                    if self.typeOfDelay == 0 {
                                        TextField("Enter minutes for notification", text: self.$delayInMinutes)
                                            .modifier(TextFieldModifier(size: 20))
                                            .keyboardType(.numberPad)
                                            //hide keyboard
                                            .onTapGesture {}
                                            .onLongPressGesture(pressing: { isPressed in if isPressed { self.endEditing() } }, perform: {})
                                    } else {
                                        TextField("Enter hours for notification", text: self.$delayInHours)
                                            .modifier(TextFieldModifier(size: 20))
                                            .keyboardType(.numberPad)
                                            //hide keyboard
                                            .onTapGesture {}
                                            .onLongPressGesture(pressing: { isPressed in if isPressed { self.endEditing() } }, perform: {})
                                    }
                                        
                                        Toggle("Is continues", isOn: self.$isContinues)
                                            .modifier(MainTextNotificationViewModifier(size: 20))
                                            .foregroundColor(self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)
                        
                                } else if self.typeOfNotification == 1 {
                               
                                    DatePicker("Select time", selection: self.$time, displayedComponents: .hourAndMinute)
                                        .modifier(MainTextNotificationViewModifier(size: 25))
                                        .foregroundColor(self.colorScheme == .light ? red : fourthTextColorDark)
                                        .buttonStyle(PlainButtonStyle())
                                    Toggle("Is continues", isOn: self.$isContinues)
                                        .modifier(MainTextNotificationViewModifier(size: 20))
                                        .foregroundColor(self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)
                                    Toggle("Days of the week", isOn: self.$showDaysOfTheWeek)
                                        .modifier(MainTextNotificationViewModifier(size: 20))
                                        .foregroundColor(self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)
                            
                                    if self.showDaysOfTheWeek {
                                        HStack {
                                            ForEach(0..<self.weekDaysArray.count, id: \.self) { day in
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
                                                    ZStack {
                                                        Rectangle()
                                                            .cornerRadius(20)
                                                            .foregroundColor(mint)
                                                        Text(self.weekDaysArray[day])
                                                            .modifier(MainTextNotificationViewModifier(size: 15))
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .foregroundColor(self.selectedButtonsArray.contains(day) ? self.activatedColor : self.deactivatedColor)
                                            }
                                        }
                                    }
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        //add alert
                                        if self.delayInMinutes.isEmpty && self.delayInHours.isEmpty && self.typeOfNotification == 0{
                                            print("empty")
                                            self.showAlert = true
                                        } else {
                                            self.setManualNotification(title: self.title, subtitle: self.subtitle)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }) {
                                        Image("setNotificationOn")
                                            .renderingMode(.original)
                                            .resizable()
                                            .modifier(CurrentImageModifier(width: 150, height: 150))
                                        Text("Set and Back")
                                            .modifier(MainTextNotificationViewModifier(size: 25))
                                            .foregroundColor(self.activatedColor)
                                    }
                                    Spacer()
                                }.buttonStyle(PlainButtonStyle())
                               
                            }
                        }
                    }
                }
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"), message: Text("Please enter \(self.typeOfDelay == 0 ? "minutes" : "hours")"), dismissButton: .default(Text("Continue")))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}



struct SetNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
