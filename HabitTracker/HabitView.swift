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

struct SectionTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
        .font(.system(size: 14, weight: .black, design: .rounded))
        //.fixedSize(horizontal: false, vertical: true)
        .foregroundColor(colorScheme == .light ? thirdTextColorLight : thirdTextColorDark)
       // .shadow(color: .black, radius: 1, x: 1, y: 1)
    }
}

struct TextFieldModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var size: CGFloat
    func body(content: Content) -> some View {
        content
        .font(.system(size: size, weight: Font.Weight.heavy, design: Font.Design.rounded))
        .foregroundColor(colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(colorScheme == .light ? blue : firstTextColorLight)
        .shadow(color: .black, radius: 1, x: 5, y: 5))
    }
}

struct CurrentImageModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(width: width, height: height)
            .shadow(color: .black, radius: 1, x: 3, y: 3)
    }
}

struct NotificationAndSaveButtonTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .black, design: .rounded))
            .foregroundColor(colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)
    }
}

struct HabitView: View {
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "colorSet1")
        
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: tabBarTextSecondaryLight], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "tabBarColor")], for: .selected)

    }
    
    @State private var habitGoal: Int16 = 0
    @State private var habitDescription = ""
    @State private var habitType = 12
    @Environment(\.colorScheme) var colorScheme
    //Image Picker
    @State private var selectedImage: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var source = 0
    func loadSelectedImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = Image(uiImage: inputImage)
        habitType = 12
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
    @State private var showNotificationSetView = false
    //binds
    @State private var id = UUID().uuidString
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
    @State private var hourFromPicker: Int = 9
    @State private var minuteFromPicker: Int = 0
    @State private var plusIsTapped = false
    @State private var minusIsTapped = false
    
    @State private var defaultORManualTypeOfNotification = TypeOfNotifications.def.rawValue
    @State private var typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
    @State private var timeForNotification = ""
    @State private var daysForNotification = ""
    @State private var delayInMinutesFromNotificationView = ""
    @State private var delayInHoursFromNotificationView = ""
    @State private var showSetButton = false
    @State private var isAnimationOn = false
    func saveToCoreData() {
        let newHabit = Habit(context: self.moc)
        newHabit.active = true
        newHabit.id = UUID()
        newHabit.name = self.habitName
        newHabit.descr = self.habitDescription
        newHabit.goal = self.habitGoal
        newHabit.typeOfAction = Int16(self.habitType)
        //Image Picker + Core Data
        newHabit.img = self.inputImage?.jpegData(compressionQuality: 1.0)
        
        //ntfn
        if self.isDefaultNotificationEnabled {
            newHabit.ntfnEnabled = true
            newHabit.typeOfNtfn = TypeOfNotifications.def.rawValue
            newHabit.idForNtfn = self.id
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        } else if self.isManualNotificationEnabled {
            newHabit.ntfnEnabled = true
            newHabit.typeOfNtfn = TypeOfNotifications.manual.rawValue
            newHabit.idForNtfn = self.id
            newHabit.isNtfnContinues = self.isContinues
            if self.typeOfNotification == 0 {
                newHabit.typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                if self.typeOfDelay == 0 {
                    newHabit.delayInMinutes = "\(self.delayInMinutes) min"
                } else {
                    newHabit.delayInHours = "\(self.delayInHours) h"
                }
            } else {
                newHabit.typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                newHabit.timeForNtfn = "\(self.hourFromPicker) : \(self.minuteFromPicker)"
                if self.showDaysOfTheWeek {
                    newHabit.daysForNtfn = self.selectedDaysArray.joined(separator: ", ")
                    }
            }
        }
            if self.moc.hasChanges {
                try? self.moc.save()
            }
            self.selectedDaysArray = []
        
        self.presentationMode.wrappedValue.dismiss()
        simpleSuccess()
    }
    
    func updateNotificationInfo() {
        if isDefaultNotificationEnabled == true {
            notificationIsEnabled = true
            defaultORManualTypeOfNotification = TypeOfNotifications.def.rawValue
        } else if isManualNotificationEnabled == true {
            notificationIsEnabled = true
            defaultORManualTypeOfNotification = TypeOfNotifications.manual.rawValue
            if typeOfNotification == 0 {
                typeOfManualNotification = TypesOfManualNotifications.delay.rawValue
                if self.typeOfDelay == 0 {
                    delayInMinutesFromNotificationView = "\(self.delayInMinutes) min"
                } else {
                    delayInHoursFromNotificationView = "\(self.delayInHours) h"
                }
            } else {
                typeOfManualNotification = TypesOfManualNotifications.timePlusDays.rawValue
                timeForNotification = "\(self.hourFromPicker) : \(self.minuteFromPicker)"
                if !selectedDaysArray.isEmpty {
                    daysForNotification = self.selectedDaysArray.joined(separator: ", ")
                }
            }
        }
    }
    
    func deleteLocalNotification(identifier: String) {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
       // ntfnIsDeleted = true
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
        
        
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                Form {
                    Section(header: Text("Habit name").modifier(SectionTextModifier())) {
                        TextField("Enter your habit name, please", text: $habitName)
                            .modifier(TextFieldModifier(size: 20))
                    }
                
                    Section(header: Text("Goal settings").modifier(SectionTextModifier())) {
                        
                        HStack {
                            Text("Set your goal for habit \(habitGoal)")
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundColor(colorScheme == .light ? red : secondTextColorDark)
                            Spacer()
                            Button(action: {
                                if self.habitGoal != 0 {
                                    self.minusIsTapped.toggle()
                                    self.habitGoal -= 1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.minusIsTapped.toggle()
                                    }
                                }
                            }) {
                                Image("minus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 70, height: 70))
                                    .scaleEffect(minusIsTapped ? 0.5 : 1)
                                    .animation(.spring())
                            }
                            Button(action: {
                                self.habitGoal += 1
                                self.plusIsTapped.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.plusIsTapped.toggle()
                                }
                            }) {
                                Image("plus")
                                    .renderingMode(.original)
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 70, height: 70))
                                    .scaleEffect(plusIsTapped ? 0.5 : 1)
                                    .animation(.spring())
                            }
                        }
                            .buttonStyle(PlainButtonStyle())
                        
                        Picker("Goal", selection: $habitGoal) {
                            ForEach(goalExamples, id: \.self) {
                                Text(String($0))
                            }
                        }   .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(colorScheme == .light ? barColorLight : blue)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                    }
                
                    Section(header: Text("Habit description").modifier(SectionTextModifier())) {
                        TextField("Enter your habit description", text: $habitDescription)
                            .disabled(validData == false)
                            .modifier(TextFieldModifier(size: 15))
                    }
                
                    //local notifications
                    Section(header:
                        HStack {
                            Text("Notification").modifier(SectionTextModifier())
                            Spacer()
                            if notificationIsEnabled {
                                Button(action: {
                                    self.deleteLocalNotification(identifier: self.id)
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
                            } else {
                                Button(action: {
                                    self.showNotificationSetView = true
                                }) {
                                    HStack {
                                        Image("notificationOn")
                                            .renderingMode(.original)
                                            .resizable()
                                            .modifier(CurrentImageModifier(width: 50, height: 50))
                                        Text("Set Notification")
                                            .modifier(NotificationAndSaveButtonTextModifier(size: 12))
                                    }
                                        .padding(.trailing, 10)
                                        .modifier(ButtonBorderModifier())
                                }
                                .opacity(validData ? 1 : 0)
                                .disabled(validData == false)
                            }
                    }) {
                        NotificationsInfoView(notificationIsEnabled: $notificationIsEnabled, typeOfNotification: $defaultORManualTypeOfNotification, typeOfManualNotification: $typeOfManualNotification, delayInMinutes: $delayInMinutesFromNotificationView, delayInHours: $delayInHoursFromNotificationView, timeForNtfn: $timeForNotification, daysForNtfn: $daysForNotification, isNtfnContinues: $isContinues, idForNtfn: $id, showSetButton: $showSetButton, showNotificationSetView: $showNotificationSetView)
                    }
                    Section(header:
                        HStack{
                            Text("Type of action").modifier(SectionTextModifier())
                            Spacer()
                            Button(action: {
                                self.showingImagePicker = true
                                self.source = 0
                            }) { Image("photo")
                                .renderingMode(.original)
                                .resizable()
                                .padding(.all, 7)
                                .modifier(ButtonBorderModifier())
                                .opacity(validData ? 1 : 0)
                                .modifier(CurrentImageModifier(width: 50, height: 50))
                                .padding(.trailing, 10)
                                
                            }
                            Button(action: {
                                self.showingImagePicker = true
                                self.source = 1
                            }) { Image("gallery")
                                .renderingMode(.original)
                                .resizable()
                                .padding(.all, 7)
                                .modifier(ButtonBorderModifier())
                                .opacity(validData ? 1 : 0)
                                .modifier(CurrentImageModifier(width: 50, height: 50))
                            }
                    }
                        .disabled(validData == false)
                            
                        .buttonStyle(BorderlessButtonStyle())
                    ) {
                        Picker("Choose type of action", selection: $habitType) {
                            ForEach(0..<12) {
                                //    VStack {
                                //   Text("Action is \($0)")
                                Image("\($0)")
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 50, height: 50))
                            }
                        }   .disabled(validData == false)
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(colorScheme == .light ? barColorLight : blue)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 1, x: 5, y: 5)
                        //Image Picker
                        HStack(alignment: .center) {
                            Spacer()
                            if selectedImage == nil || habitType != 12 {
                                Image("\(habitType)")
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 250, height: 250))
                                    .rotation3DEffect(.degrees(self.isAnimationOn ? 20 : -20), axis: (x: 10 , y: 40, z: 10))
                                    .animation(
                                        Animation.easeOut(duration: 3)
                                            .repeatForever(autoreverses: true)
                                    )
                                    .onAppear {
                                        self.isAnimationOn.toggle()
                                    }
                            } else if selectedImage != nil {
                                selectedImage?
                                    .resizable()
                                    .cornerRadius(20)
                                    .modifier(CurrentImageModifier(width: 250, height: 250))
                                    .rotation3DEffect(.degrees(self.isAnimationOn ? 20 : -20), axis: (x: 10 , y: 40, z: 10))
                                    .animation(
                                        Animation.easeOut(duration: 3)
                                            .repeatForever(autoreverses: true)
                                    )
                                    .onAppear {
                                        self.isAnimationOn.toggle()
                                    }
                            }
                            Spacer()
                        }
                        
                        
                    }
                    .sheet(isPresented: $showNotificationSetView , onDismiss: updateNotificationInfo) { SetNotificationsView(id: self.$id, isDefaultNotificationEnabled: self.$isDefaultNotificationEnabled, isManualNotificationEnabled: self.$isManualNotificationEnabled, habitName: self.$habitName, typeOfNotification: self.$typeOfNotification, delayInMinutes: self.$delayInMinutes, delayInHours: self.$delayInHours, typeOfDelay: self.$typeOfDelay, isContinues: self.$isContinues, showDaysOfTheWeek: self.$showDaysOfTheWeek, selectedDaysArray: self.$selectedDaysArray, hours: self.$hourFromPicker, minutes: self.$minuteFromPicker)
                    }
                }
            }   .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitle("New habit", displayMode: .inline)
                .navigationBarItems(leading:
                    Button("Save habit"){
                        self.saveToCoreData()
                    }
                    .modifier(NotificationAndSaveButtonTextModifier(size: 20))
                    .opacity(validData ? 1 : 0)
                    .disabled(validData == false)
            )
                .sheet(isPresented: $showingImagePicker, onDismiss: loadSelectedImage) {
                    ImagePicker(image: self.$inputImage, typeOfSource: self.$source)
            }
        }
    }
}




struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}
