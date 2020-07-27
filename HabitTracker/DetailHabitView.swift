//
//  DetailHabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailHabitView: View {
    //Core Data
    var habit: Habit
    @FetchRequest(entity: Habit.entity(), sortDescriptors: []) var habits: FetchedResults<Habit>
    @Environment(\.managedObjectContext) var moc
    
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
        }
         
        
        
    }
}



 

struct DetailHabitView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
