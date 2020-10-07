//
//  MainHabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 06.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct MainViewSubTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .black, design: .rounded))
    }
}

struct MainHabitView: View {
    
    enum PredicateType {
        case active
        case completed
    }

    var fetchRequest: FetchRequest<Habit>
    
    init(predicateType: PredicateType) {
        UITableView.appearance().backgroundColor = .clear // tableview background
        UITableViewCell.appearance().backgroundColor = .clear // cell background
        
        var pred: NSPredicate {
            switch predicateType {
                case .active:
                    return NSPredicate(format: "active == %@", NSNumber(value: true))
                case .completed:
                    return NSPredicate(format: "active == %@", NSNumber(value: false))
                }
            }
            
        fetchRequest = FetchRequest<Habit>(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)], predicate: pred)
    }
    //Core Data
    @Environment(\.managedObjectContext) var moc
    //resize during edit mode
    @State var isEditMode: EditMode = .inactive
    @Environment(\.presentationMode) var presentationMode
    @State private var showInfo = false
    @State private var isAnimationOn = false
    @Environment(\.colorScheme) var colorScheme
    func deleteLocalNotification(identifier: String) {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    //Core Data
    func removeHabits(at offsets: IndexSet) {
        for offset in offsets {
            let habit = fetchRequest.wrappedValue[offset]
            let notifCenter = UNUserNotificationCenter.current()
            if habit.ntfnEnabled{
                deleteLocalNotification(identifier: habit.idForNtfn!)
            }
            moc.delete(habit)
        }
        try? moc.save()
    }
    //load image object from Core Data
    func imageFromCoreData(habit: Habit) -> UIImage {
        var imageToLoad = UIImage(named: "14")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(named: "14")!
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    var body: some View {
        NavigationView {
         //   GeometryReader { geo in
                ZStack {
                    self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                
                    VStack {
                        //!
                        GeometryReader { geo in
                        List {
                            ForEach(self.fetchRequest.wrappedValue, id: \.id) {
                                habit in
                                NavigationLink(destination: DetailHabitView(habit: habit)) {
                                    HStack(alignment: .center, spacing: 5) {
                                        Text(habit.wrappedName)
                                            .font(.system(size: self.isEditMode == .active ? 10 : 20, weight: .black, design: .rounded))
                                            .foregroundColor(self.colorScheme == .light ?  firstTextColorLight: firstTextColorDark)
                                       
                                            //firstTextColorLight firstTextColorDark
                                            //                     thirdTextColorDark
                                            .frame(width: geo.size.width * 0.25, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .contextMenu {
                                                Button(action: {
                                                    habit.steps += 1
                                                    if habit.wrappedGoal != nil && habit.wrappedSteps != 0 {
                                                        habit.percentCompletion = Float((100 * habit.wrappedSteps) / habit.wrappedGoal)
                                                    }
                                                    if habit.wrappedGoal == habit.wrappedSteps {
                                                        habit.active = false
                                                        if habit.ntfnEnabled {
                                                            self.deleteLocalNotification(identifier: habit.idForNtfn!)
                                                            habit.ntfnEnabled = false
                                                            habit.daysForNtfn = nil
                                                            habit.delayInHours = nil
                                                            habit.delayInMinutes = nil
                                                            habit.isNtfnContinues = false
                                                            habit.timeForNtfn = nil
                                                            habit.typeOfManualNotification = nil
                                                            habit.typeOfNtfn = nil
                                                            habit.idForNtfn = nil
                                                        }
                                                    }
                                                    try? self.moc.save()
                                                    self.simpleSuccess()
                                                }) {
                                                    HStack {
                                                        Text("Tap to add one step to your goal")
                                                        Image("tap")
                                                    }
                                                }
                                            }
                                        //.padding(.trailing, 20)
                                        VStack(alignment: .leading) {
                                            Text("Goal: \(habit.wrappedGoal)")
                                                .modifier(MainViewSubTextModifier())
                                                .foregroundColor(self.colorScheme == .light ?  mint: secondTextColorDark)

                                            Text("Streaks: \(habit.wrappedSteps)")
                                                .modifier(MainViewSubTextModifier())
                                                .foregroundColor(self.colorScheme == .light ?  fourthTextColorDark: fourthTextColorDark)
                            
                                            Text("Progress:")
                                                .modifier(MainViewSubTextModifier())
                                                .foregroundColor(self.colorScheme == .light ?  orange: thirdTextColorDark)
                                            ProgressBar(percent: CGFloat(habit.percentCompletion))
                                                .shadow(color: .black, radius: 1, x: 3, y: 3)
                                    
                                        }
                                            //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
                                            .frame(width: geo.size.width * 0.25, alignment: .leading)
                                        Spacer()
                                    
                                        //Core Data + image from ImagePicker
                                        if habit.typeOfAction != 14 {
                                            Image("\(habit.typeOfAction)")
                                                .resizable()
                                                .modifier(CurrentImageModifier(width: self.isEditMode == .active ? 50 : geo.size.width * 0.25, height: self.isEditMode == .active ? 50 : 80))
                                                .animation(nil)
                                                .rotation3DEffect(.degrees(self.isAnimationOn ? 10 : -10), axis: (x: 0 , y: 5, z: 0))
                                                .animation(
                                                    Animation.easeOut(duration: 3)
                                                        .repeatForever(autoreverses: true)
                                                )
                                                .onAppear {
                                                    self.isAnimationOn = true
                                                }
                                        } else {
                                            Image(uiImage: self.imageFromCoreData(habit: habit))
                                                .resizable()
                                                .cornerRadius(20)
                                                .modifier(CurrentImageModifier(width: self.isEditMode == .active ? 50 : geo.size.width * 0.25, height: self.isEditMode == .active ? 50 : 80))
                                                .animation(nil)
                                                .rotation3DEffect(.degrees(self.isAnimationOn ? 10 : -10), axis: (x: 0 , y: 5, z: 0))
                                                .animation(
                                                    Animation.easeOut(duration: 3)
                                                        .repeatForever(autoreverses: true)
                                                )
                                        
                                        }
                                    }
                                        .padding()
                                        .modifier(ButtonBorderModifier())
                                    //окончание navlink
                                }
                            }.onDelete(perform: self.removeHabits)
                        }
                            //!
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
           // }
            
                .navigationBarTitle("Habitent", displayMode: .inline)
                .navigationBarItems(leading:
                        HStack {
                            EditButton()
                        },  trailing: HStack {
                            Button(action: {
                                self.showInfo.toggle()
                            }) {
                                Image(systemName: "info")
                            }
                })
                .environment(\.editMode, self.$isEditMode)
                .sheet(isPresented: $showInfo) { InfoView()
                }
        }
    }
}

struct MainHabitView_Previews: PreviewProvider {
    static var previews: some View {
        MainHabitView(predicateType: .active)
    }
 }
