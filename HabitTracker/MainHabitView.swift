//
//  MainHabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 06.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

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
    @State private var habitViewOpen = false
    @Environment(\.presentationMode) var presentationMode
       
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
        var imageToLoad = UIImage(systemName: "xmark")
        if let data = habit.img {
            if let image = UIImage(data: data) {
                imageToLoad = image
            }
        }
        return imageToLoad ?? UIImage(systemName: "xmark") as! UIImage
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.942, green: 0.993, blue: 0.716)
                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(fetchRequest.wrappedValue, id: \.id) {
                        habit in
                        NavigationLink(destination: DetailHabitView(habit: habit)) {
                            HStack(alignment: .center, spacing: 20) {
                                Text(habit.wrappedName)
                                    .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                                    .foregroundColor(.orange)
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
                                            Image(systemName: "plus")
                                        }
                                    }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Goal: \(habit.wrappedGoal)")
                                        .font(.system(size: 15, weight: .black, design: .rounded))
                                        .foregroundColor(.purple)

                                    Text("Streaks: \(habit.wrappedSteps)")
                                        .font(.system(size: 17, weight: Font.Weight.black, design: Font.Design.rounded))
                                        .foregroundColor(.gray)
                                
                                    Text("Progress:")
                                        .font(.system(size: 15, weight: .black, design: .rounded))
                                        .foregroundColor(Color.init(red: 1, green: 0.247, blue: 0.357))
                                    ProgressBar(percent: CGFloat(habit.percentCompletion))
                                    
                                }   //Core Data + image from ImagePicker
                                if habit.typeOfAction != 11 {
                                    Image("\(habit.typeOfAction)")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .scaledToFit()
                                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                                } else {
                                    Image(uiImage: self.imageFromCoreData(habit: habit))
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .scaledToFit()
                                }
                            }
                            //окончание navlink
                        }
                    }.onDelete(perform: removeHabits)
                }
            }
                .navigationBarTitle("Habit tracker", displayMode: .inline)
                .navigationBarItems(leading:
                        HStack {
                            EditButton()
                        },  trailing: HStack {
                            Button(action: {
                                self.habitViewOpen.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                                                                                //Core Data
                }) .sheet(isPresented: $habitViewOpen) { HabitView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
}

struct MainHabitView_Previews: PreviewProvider {
    static var previews: some View {
        MainHabitView(predicateType: .active)
    }
 }
