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

struct HabitAndDescriptionTitleTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
            .foregroundColor(colorScheme == .light ? thirdTextColorLight : thirdTextColorDark)
    }
}

struct HabitAndDescriptionContentTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 23, weight: Font.Weight.bold, design: Font.Design.rounded))
            .foregroundColor(colorScheme == .light ? firstTextColorLight : firstTextColorDark)
    }
}

struct CircleSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 110, height: 110, alignment: .center)
    }
}

struct CircleColorAndShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? blue : firstTextColorLight)
            .shadow(color: .black, radius: 1, x: 5, y: 5)
    }
}

struct GoalDigitsColorAndFontModifier:ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .black, design: .rounded))
            .foregroundColor(red)
            .shadow(color: .black, radius: 1, x: 2, y: 2)
    }
}

struct StepsDigitsColorAndFontModifier:ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .black, design: .rounded))
            .foregroundColor(secondTextColorDark)
            .shadow(color: .black, radius: 1, x: 2, y: 2)
    }
}

struct ButtonBorderModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(self.colorScheme == .light ? barColorLight : tabBarTextPrimaryDarkColor, lineWidth: 3)
                        .shadow(color: .black, radius: 1, x: 2, y: 2)
            )
            .buttonStyle(PlainButtonStyle())
    }
}

struct DetailHabitView: View {
    //Core Data
    var habit: Habit
    @FetchRequest(entity: Habit.entity(), sortDescriptors: []) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var moc
    @Environment (\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
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
    @State private var isCompleted = false
    @State private var isAnimationOn = false
    @State private var showNotificationInfo = false
    @State private var showDeleteButton = false
    @State private var isDeleteButtonTApped = false
    @State private var isPlusButtonTapped = false
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
        habitName = habit.name ?? "Do it now"
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
    
    func isOdd(number: Int) -> Int {
        return number % 2
    }
    
    var body: some View {
        ZStack {
            colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
            GeometryReader { geo in
                Form {
                
                    VStack(alignment: .leading, spacing: 10) {
                    
                        HStack {
                            Text("Habit name:")
                                .modifier(HabitAndDescriptionTitleTextModifier())
                            Text(self.habit.wrappedName)
                                .modifier(HabitAndDescriptionContentTextModifier())
                        }
                            .onAppear {
                                self.updateDataForNotificationInfoView()
                            }
            
                        HStack {
                            Text("Habit description:")
                                .modifier(HabitAndDescriptionTitleTextModifier())
                            Text(self.habit.wrappedDescr)
                                .modifier(HabitAndDescriptionContentTextModifier())
                        }
             
                        HStack(alignment: .center) {
                            Spacer()
                            //Core Data + Image Picker
                            if  self.habit.img == nil {
                                Image("\(self.habit.typeOfAction)")
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: geo.size.width, height: 150))
                            } else {
                                Image(uiImage: self.imageFromCoreData(habit: self.habit))
                                    .resizable()
                                    .cornerRadius(20)
                                    .modifier(CurrentImageModifier(width: geo.size.width, height: 150))
                            }
                            Spacer()
                        }   .rotation3DEffect(.degrees(self.isAnimationOn ? 10 : -10), axis: (x: 0 , y: 5, z: 0))
                            .animation(
                                Animation.easeOut(duration: 3)
                                    .repeatForever(autoreverses: true)
                            )
                        
        
                        HStack(alignment: .top) {
                            Spacer ()
                            
                            ZStack{
                                Capsule()
                                    .modifier(CircleSizeModifier())
                                    .modifier(CircleColorAndShadowModifier())
                                Image("goal5")
                                    .resizable()
                                    .frame(width: 110, height: 110, alignment: .center)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                                Text("\(self.habit.wrappedGoal)")
                                    .modifier(GoalDigitsColorAndFontModifier())
                            }
                            
                            Spacer ()
                            
                            ZStack{
                                Capsule()
                                    .modifier(CircleSizeModifier())
                                    .modifier(CircleColorAndShadowModifier())
                                Image("drop5")
                                    .resizable()
                                    .frame(width: 120, height: 120, alignment: .center)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                                Text("\(self.habit.wrappedSteps)")
                                    .modifier(StepsDigitsColorAndFontModifier())
                            }
                        
                            Spacer ()
                            
                            ProgressCircle(percent: CGFloat(self.habit.percentCompletion))
                                .padding(.top, 10)
                       
                            Spacer ()
                        }
                    
                        if self.habit.active {
                            HStack {
                                Text("Show notification info")
                                    .modifier(SectionTextModifier())
                                Spacer()
                                Button(action: {
                                    self.showNotificationInfo.toggle()
                                }) {
                                    Image(self.showNotificationInfo ? "toggleOn" : "toggleOff")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70, alignment: .center)
                                }
                            }
                        } else {
                            Spacer()
                        }
                    
                        if self.showNotificationInfo {
                            VStack {
                                if self.notificationIsEnabled && self.habit.active {
                                    Button(action: {
                                        self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
                                    }){
                                        HStack {
                                            Image("setNotificationOff")
                                                .renderingMode(.original)
                                                .resizable()
                                                .modifier(CurrentImageModifier(width: 50, height: 50))
                                            Text("Cancel notification")
                                                .modifier(NotificationAndSaveButtonTextModifier(size: 12))
                                        }
                                            .padding(.trailing, 10)
                                            .modifier(ButtonBorderModifier())
                                    }
                                } else if !self.showNotificationSetView && self.habit.active {
                                    Button(action: {
                                        self.showNotificationSetView = true
                                    }) {
                                        HStack {
                                            Image("notificationOn")
                                                .renderingMode(.original)
                                                .resizable()
                                                .modifier(CurrentImageModifier(width: 50, height: 50))
                                            Text("Set notification")
                                                .modifier(NotificationAndSaveButtonTextModifier(size: 12))
                                        }
                                            .padding(.trailing, 10)
                                            .modifier(ButtonBorderModifier())
                                    }
                                }
                                if self.habit.active {
                                    NotificationsInfoView(notificationIsEnabled: self.$notificationIsEnabled, typeOfNotification: self.$defaultORManualTypeOfNotification, typeOfManualNotification: self.$typeOfManualNotification, delayInMinutes: self.$delayInMinutesFromNotificationView, delayInHours: self.$delayInHoursFromNotificationView, timeForNtfn: self.$timeForNotification, daysForNtfn: self.$daysForNotification, isNtfnContinues: self.$isContinues, idForNtfn: self.$id, showSetButton: self.$showSetButton, showNotificationSetView: self.$showNotificationSetView)
                                    }
                            }
                        }
                        
                        HStack(alignment: .center) {
                           
                            if self.habit.active {
                                Spacer()
                                Button(action: {
                                    self.isPlusButtonTapped = true
                                    self.habit.steps += 1
                                    self.habit.percentCompletion = self.percentOfGoal
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.12) {
                                        self.isPlusButtonTapped = false
                                    }
                                        if self.habit.steps == self.habit.wrappedGoal {
                                            self.isCompleted.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                                
                                                self.habit.active = false
                                                if self.notificationIsEnabled {
                                                    self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
                                                } else {
                                                //bug solution
                                                    self.notificationIsEnabled = true
                                                }
                                                if self.moc.hasChanges {
                                                        try? self.moc.save()
                                                    }
                                               
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                       self.simpleSuccess()
                                }) {
                                    Image(self.isPlusButtonTapped ? "tappedButton" : "tapButton")
                                        .renderingMode(.original)
                                        .resizable()
                                        .modifier(CurrentImageModifier(width: 200, height: 200))
                                    
                                        .rotation3DEffect(.degrees(self.isAnimationOn ? 5 : -5), axis: (x: 5 , y: 0, z: 0))
                                        .animation(
                                            Animation.easeOut(duration: 3)
                                                .repeatForever(autoreverses: true)
                                        )
                                        .onAppear {
                                        self.isAnimationOn.toggle()
                                        }
                                }
                                Spacer()
                            } else {
                            
                                Image("done")
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 200, height: 200))
                                    .scaleEffect(self.isAnimationOn ? 1.2 : 1)
                                    .rotation3DEffect(.degrees(self.isAnimationOn ? 40 : -40), axis: (x: 1 , y: 1, z: 1))
                                    .animation(
                                        Animation.easeOut(duration: 3)
                                            .repeatForever(autoreverses: true)
                                    )
                                .onAppear {
                                    self.isAnimationOn.toggle()
                                }
                                
                                Text("Completed")
                                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                                    .foregroundColor(self.colorScheme == .light ? red : yellow)
                                    .shadow(color: .black, radius: 1, x: 2, y: 2)
                                    .scaleEffect(self.isAnimationOn ? 1.2 : 1)
                                    .animation(
                                        Animation.easeOut(duration: 3)
                                            .repeatForever(autoreverses: true)
                                    )
                            }
                            
                        }
                            .padding(.top, -20)
                    
                        Spacer()
                
                        HStack {
                            Text("Show delete button")
                                .modifier(SectionTextModifier())
                            Spacer()
                            Button(action: {
                                self.showDeleteButton.toggle()
                            }) {
                                Image(self.showDeleteButton ? "toggleOn" : "toggleOff")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70, alignment: .center)
                            }
                        }
                    
                        HStack(alignment: .center) {
                            Spacer()
                   
                            if self.showDeleteButton {
                                VStack(spacing: -20) {
                                    Button(action: {
                                        self.isDeleteButtonTApped.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            if self.notificationIsEnabled {
                                                self.deleteLocalNotification(identifier: self.habit.idForNtfn!)
                                            }
                                            self.moc.delete(self.habit)
                                            try? self.moc.save()
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }) {
                                        Image("delete")
                                            .renderingMode(.original)
                                            .resizable()
                                            .modifier(CurrentImageModifier(width: 150, height: 150))
                                            .rotation3DEffect(.degrees(self.isDeleteButtonTApped ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                                            .animation(.spring(response: 0.55, dampingFraction: 2, blendDuration: 4))
                                    }
                                    Text("Delete")
                                        .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                                        .foregroundColor(self.colorScheme == .light ? red : fourthTextColorDark)
                                
                                }
                            }
                        }
                    
                    }.animation(.easeInOut)
                }
                    .padding(.top, -40)
                    .buttonStyle(PlainButtonStyle())
        
                    HStack(alignment: .center) {
                        Spacer()
                        ForEach(1 ..< 7) { image in
                            Image("thumbsUp")
                                .resizable()
                                .frame(width: CGFloat(50), height: CGFloat(50))
                                .offset(x: CGFloat(image) * geo.size.width * 0.002 , y: !self.isCompleted ? geo.size.height + 100 : -300)
                                .shadow(color: .black, radius: 1, x: 2, y: 2)
                                .animation(.spring(response: 3, dampingFraction: 3, blendDuration: 5))
                        }
                        Spacer()
                    }
                }
            }   .sheet(isPresented: $showNotificationSetView, onDismiss: updateCoreDataAndNotificationInfoData) { SetNotificationsView(id: self.$id, isDefaultNotificationEnabled: self.$isDefaultNotificationEnabled, isManualNotificationEnabled: self.$isManualNotificationEnabled, habitName: self.$habitName, typeOfNotification: self.$typeOfNotification, delayInMinutes: self.$delayInMinutes, delayInHours: self.$delayInHours, typeOfDelay: self.$typeOfDelay, isContinues: self.$isContinues, showDaysOfTheWeek: self.$showDaysOfTheWeek, selectedDaysArray: self.$selectedDaysArray, hours: self.$hourFromPicker, minutes: self.$minuteFromPicker) }
    }
}



 

struct DetailHabitView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
