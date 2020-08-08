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
       // guard let index = habits.firstIndex(where: { $0.id == habit.id}) else {return}
      //  habits[index].steps = habit.steps
        if self.moc.hasChanges {
            try? self.moc.save()
        }
    }
    
    var percentOfGoal: Float {
        var tempPercent: Float = 0.0
        if habit.goal != nil && habit.steps != 0 {
            let percent = (100 * habit.steps) / habit.goal
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
        notificationIsEnabled = false
        habit.ntfnEnabled = false
        habit.daysForNtfn = nil
        habit.delayInHours = nil
        habit.delayInMinutes = nil
        habit.isNtfnContinues = false
        habit.timeForNtfn = nil
        habit.typeOfManualNotification = nil
        habit.typeOfNtfn = nil
        habit.idForNtfn = nil
        if self.moc.hasChanges {
            try? self.moc.save()
        }
        notificationIsEnabled = false
        isDefaultNotificationEnabled = false
        isManualNotificationEnabled = false
        delayInMinutesFromNotificationView = ""
        delayInHoursFromNotificationView = ""
        timeForNotification = ""
        daysForNotification = ""
        selectedDaysArray = []
        delayInMinutes = ""
        delayInHours = ""
        showSetButton = true
        simpleSuccess()
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
    
    @State private var notificationIsEnabled = true
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
    
    @State private var defaultORManualTypeOfNotification = TypeOfNotifications.def.rawValue
    @State private var typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
    @State private var timeForNotification = ""
    @State private var daysForNotification = ""
    @State private var delayInMinutesFromNotificationView = ""
    @State private var delayInHoursFromNotificationView = ""
    @State private var showSetButton = true
    
    func updateCoreDataAndNotificationInfoData() {
        
        if self.isDefaultNotificationEnabled {
            habit.ntfnEnabled = true
            notificationIsEnabled = true
            habit.typeOfNtfn = TypeOfNotifications.def.rawValue
            defaultORManualTypeOfNotification = TypeOfNotifications.def.rawValue
            habit.idForNtfn = self.id
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        } else if self.isManualNotificationEnabled {
            habit.ntfnEnabled = true
            notificationIsEnabled = true
            habit.typeOfNtfn = TypeOfNotifications.manual.rawValue
            defaultORManualTypeOfNotification = TypeOfNotifications.manual.rawValue
            habit.idForNtfn = self.id
            habit.isNtfnContinues = self.isContinues
            if self.typeOfNotification == 0 {
                habit.typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                if self.typeOfDelay == 0 {
                    habit.delayInMinutes = "\(self.delayInMinutes) min"
                    delayInMinutesFromNotificationView = "\(self.delayInMinutes) min"
                } else {
                    habit.delayInHours = "\(self.delayInHours) h"
                    delayInHoursFromNotificationView = "\(self.delayInHours) h"
                }
            } else {
                habit.typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                habit.timeForNtfn = "\(self.hourFromPicker) : \(self.minuteFromPicker)"
                timeForNotification = "\(self.hourFromPicker) : \(self.minuteFromPicker)"
                if self.showDaysOfTheWeek {
                    habit.daysForNtfn = self.selectedDaysArray.joined(separator: ", ")
                    daysForNotification = self.selectedDaysArray.joined(separator: ", ")
                }
            }
        }
            if self.moc.hasChanges {
                try? self.moc.save()
            }
            self.selectedDaysArray = []
    }
    
    func updateDataForNotificationInfoView() {
        habitName = habit.name ?? "Do it"
        if self.habit.ntfnEnabled == true {
            self.notificationIsEnabled = true
            defaultORManualTypeOfNotification = habit.wrappedTypeOfNtfn
            typeOfManualNotification = habit.wrappedTypeOfManualNotification
            delayInMinutesFromNotificationView = habit.wrappedDelayInMinutes
            delayInHoursFromNotificationView = habit.wrappedDelayInHours
            timeForNotification = habit.wrappedTimeForNtfn
            daysForNotification = habit.wrappedDaysForNtfn
            isContinues = habit.isNtfnContinues
            id = habit.idForNtfn ?? UUID().uuidString
            showSetButton = false
        } else {
            self.notificationIsEnabled = false
            showSetButton = true
        }
    }
    
    public func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
                        Text(self.habit.wrappedName)
                            .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                            .foregroundColor(.orange)
                    } .onAppear {
                        self.updateDataForNotificationInfoView()
                    }
            
                    HStack {
                        Text("Habit description: ")
                            .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
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
        
                HStack(spacing: 20) {
                    VStack{
                        Text("Goal")
                            .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                        ZStack{
                            Capsule()
                                .frame(width: 100, height: 100, alignment: .center)
                                .shadow(color: .orange, radius: 1, x: 5, y: 5)
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
                if habit.active {
                NotificationsInfoView(notificationIsEnabled: $notificationIsEnabled, typeOfNotification: $defaultORManualTypeOfNotification, typeOfManualNotification: $typeOfManualNotification, delayInMinutes: $delayInMinutesFromNotificationView, delayInHours: $delayInHoursFromNotificationView, timeForNtfn: $timeForNotification, daysForNtfn: $daysForNotification, isNtfnContinues: $isContinues, idForNtfn: $id, showSetButton: $showSetButton, showNotificationSetView: $showNotificationSetView)
                    .frame(height: 300)
                }
                //solution
                if notificationIsEnabled && habit.active {
                    Button(action: {
                        self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
                    }){
                        Text("Cancel notification")
                    }
                }
            
                if habit.active {
                
                Button(action: {
                     self.habit.steps += 1
                     self.habit.percentCompletion = self.percentOfGoal
                        if self.habit.steps == self.habit.wrappedGoal {
                            self.habit.active = false
                            if self.notificationIsEnabled {
                                self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
                            } else {
                                //solution
                                self.notificationIsEnabled = true
                            }
                        }
                        if self.moc.hasChanges {
                            try? self.moc.save()
                        }
                    self.simpleSuccess()
                    }) {
                        Image("push")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Capsule())
                            .frame(width: 300, height: 300)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                        }
                    } else {
                        Image("6")
                        Text("completed")
                    }
                }
            }.sheet(isPresented: $showNotificationSetView, onDismiss: updateCoreDataAndNotificationInfoData) { SetNotificationsView(id: self.$id, isDefaultNotificationEnabled: self.$isDefaultNotificationEnabled, isManualNotificationEnabled: self.$isManualNotificationEnabled, habitName: self.$habitName, typeOfNotification: self.$typeOfNotification, delayInMinutes: self.$delayInMinutes, delayInHours: self.$delayInHours, typeOfDelay: self.$typeOfDelay, isContinues: self.$isContinues, showDaysOfTheWeek: self.$showDaysOfTheWeek, selectedDaysArray: self.$selectedDaysArray, hours: self.$hourFromPicker, minutes: self.$minuteFromPicker)
        }
    }
}



 

struct DetailHabitView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
