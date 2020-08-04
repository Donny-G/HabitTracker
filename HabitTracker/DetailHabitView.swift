//
//  DetailHabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreData
import UserNotifications

struct DetailHabitView: View {
    //Core Data
    var habit: Habit
    @FetchRequest(entity: Habit.entity(), sortDescriptors: []) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var moc
    @Environment (\.presentationMode) var presentationMode
    
    //Core Data
    func updateValues(){
        guard let index = habits.firstIndex(where: { $0.id == habit.id
        }) else {return}
        habits[index].steps = habit.steps
        if self.moc.hasChanges {
        try? self.moc.save()
        }
    }
    
    var percentOfGoal: Float {
        var tempPercent: Float = 0.0
        //Core Data
        if habit.wrappedGoal != nil && habit.wrappedSteps != 0 {
            let percent = (100 * habit.wrappedSteps) / habit.wrappedGoal
        
            tempPercent = Float(percent)
        }
        return tempPercent
    }
    
    //load image object from Core Data
    func imageFromCoreData(habit: Habit) -> UIImage {
        var imageToLoad = UIImage(systemName: "xmark")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(systemName: "xmark") as! UIImage
    }
    
    //local notifications
    func deleteLocalNotification(identifier: String) {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        ntfnIsDeleted = true
        habit.ntfnEnabled = false
        habit.daysForNtfn = nil
        habit.delayInHours = nil
        habit.delayInMinutes = nil
        habit.isNtfnContinues = false
        habit.timeForNtfn = nil
        habit.typeOfManualNotification = nil
        habit.typeOfNtfn = nil
        habit.isDeletedNtfn = true
        habit.idForNtfn = nil
        if self.moc.hasChanges {
            try? self.moc.save()
        }
        
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
    
    @State private var ntfnIsDeleted = false
    @State private var showNotificationSetView = false
    //binds
    @State var id = UUID().uuidString
    @State private var isDefaultNotificationEnabled = false
    @State private var isManualNotificationEnabled = false
    @State private var habitName = ""
    @State private var typeOfNotification = 0
    @State private var delayInMinutes = ""
    @State private var delayInHours = ""
    @State private var typeOfDelay = 0
    @State private var isContinues = false
    @State private var showDaysOfTheWeek = false
    @State private var selectedDaysArray = [String]()
    @State var hourFromPicker: Int = 9
    @State var minuteFromPicker: Int = 0
    
    func updateCoreData() {
        if self.isDefaultNotificationEnabled {
            habit.ntfnEnabled = true
            habit.typeOfNtfn = TypeOfNotifications.def.rawValue
            habit.idForNtfn = self.id
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        } else if self.isManualNotificationEnabled {
            habit.ntfnEnabled = true
            habit.typeOfNtfn = TypeOfNotifications.manual.rawValue
            habit.idForNtfn = self.id
            habit.isNtfnContinues = self.isContinues
            if self.typeOfNotification == 0 {
                habit.typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                if self.typeOfDelay == 0 {
                    habit.delayInMinutes = "\(self.delayInMinutes) min"
                } else {
                    habit.delayInHours = "\(self.delayInHours) h"
                }
            } else {
                habit.typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                habit.timeForNtfn = "\(self.hourFromPicker) : \(self.minuteFromPicker)"
                if self.showDaysOfTheWeek {
                    habit.daysForNtfn = self.selectedDaysArray.joined(separator: ", ")
                    }
            }
        }
            if self.moc.hasChanges {
                try? self.moc.save()
            }
            self.selectedDaysArray = []
    }
    
    
    var body: some View {
        ZStack {
                       Color(red: 0.942, green: 0.993, blue: 0.716)
                       .edgesIgnoringSafeArea(.all)
     ScrollView {
           
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Habit name:")
                        .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                    //Core Data
                    Text(self.habit.wrappedName)
                    .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                    .foregroundColor(.orange)
                }
            
                HStack {
                    Text("Habit description: ")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                    //Core Data
                    Text(self.habit.wrappedDescr)
                    .font(.system(size: 20, weight: Font.Weight.bold, design: Font.Design.rounded))
                    .foregroundColor(.gray)
                }
                
        }
        //Core Data + Image Picker
        if habit.typeOfAction != 11 {
            Image("\(self.habit.typeOfAction)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
         } else {
            Image(uiImage: imageFromCoreData(habit: habit))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
        }
        
        HStack(spacing: 20){
                VStack{
                    Text("Goal")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                ZStack{
                    Capsule()
                        .frame(width: 100, height: 100, alignment: .center)
                    .shadow(color: .orange, radius: 1, x: 5, y: 5)
                    //Core Data
                    Text("\(self.habit.wrappedGoal)")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(.orange)
                    }
                }
                VStack {
                    Text("Streaks")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                    ZStack{
                    Capsule()
                        .shadow(color: .orange, radius: 1, x: 5, y: 5)
                        .frame(width: 100, height: 100, alignment: .center)
                        //Core Data
                        Text("\(self.habit.wrappedSteps)")
                    .font(.system(size: 30, weight: Font.Weight.black, design: Font.Design.rounded))
                        .foregroundColor(Color.init(red: 0.239, green: 0.694, blue: 0.557))
                    }
                }
                VStack {
                    Text("Progress:")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                
                ProgressCircle(percent: CGFloat(habit.percentCompletion))
                }
            }
        
        //ntfn
        if habit.ntfnEnabled == true {
            //Default
            HStack {
                Text("Notification")
                Image(systemName: "checkmark.rectangle")
            }
            
            HStack {
                Text("Type of notification")
                Image(systemName: habit.typeOfNtfn == TypeOfNotifications.def.rawValue ? "gear" : "hand.raised.fill")
            }
        //manual
            if habit.typeOfNtfn != TypeOfNotifications.def.rawValue {
                HStack {
                    Image(systemName: habit.typeOfManualNotification == TypesOfManualNotifications.delay.rawValue ? "timer" : "alarm")
                    if habit.delayInMinutes != nil || habit.delayInHours != nil {
                        Text(habit.delayInMinutes != nil ? habit.wrappedDelayInMinutes : habit.wrappedDelayInHours)
                    } else {
                        Text(habit.wrappedTimeForNtfn)
                    }
                }
                
                if habit.daysForNtfn != nil {
                    HStack {
                        Image(systemName: "calendar")
                        Text(habit.wrappedDaysForNtfn)
                    }
                }
                
                HStack {
                    Text("Is continues")
                    Image(systemName: habit.isNtfnContinues ? "checkmark.rectangle" : "rectangle")
                }
            }
            
            Button(action: {
                self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
            }){
                Text("Cancel notification")
            }
            
            Button(action: {
                self.checkLocalNotifications()
            }) {
                Text("Check")
            }
        } else {
            HStack {
                Text("Notification")
                Image(systemName: "rectangle")
            }
            if ntfnIsDeleted || habit.isDeletedNtfn || !habit.ntfnEnabled{
                Button(action: {
                    self.habitName = self.habit.name ?? "Do it"
                    self.showNotificationSetView = true
                }) {
                    Text("Set new notification")
                }
            }
        }
            //Core Data
            Button(action: {
                self.habit.steps += 1
                self.habit.percentCompletion = self.percentOfGoal
                print(self.percentOfGoal)
                self.updateValues()
            }) {
                Image("push")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                    
                .clipShape(Capsule())
                .frame(width: 300, height: 300)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
            }
      
               
            }
        }.sheet(isPresented: $showNotificationSetView, onDismiss: updateCoreData) { SetNotificationsView(id: self.$id, isDefaultNotificationEnabled: self.$isDefaultNotificationEnabled, isManualNotificationEnabled: self.$isManualNotificationEnabled, habitName: self.$habitName, typeOfNotification: self.$typeOfNotification, delayInMinutes: self.$delayInMinutes, delayInHours: self.$delayInHours, typeOfDelay: self.$typeOfDelay, isContinues: self.$isContinues, showDaysOfTheWeek: self.$showDaysOfTheWeek, selectedDaysArray: self.$selectedDaysArray, hours: self.$hourFromPicker, minutes: self.$minuteFromPicker)
        }
         
        
        
    }
}



 

struct DetailHabitView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
