//
//  DetailHabitView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct DetailHabitView: View {
 @State  var habit: HabitItem
   @ObservedObject var habits: Habits
    
    //находим элемент массива с id и обновляем аргументы
    func updateValues(){
        guard let index = habits.habitItems.firstIndex(where: { $0.id == habit.id
        }) else {return}
        habits.habitItems[index].steps = habit.steps
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
                    Text(self.habit.name)
                    .font(.system(size: 25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                    .foregroundColor(.orange)
                }
            
                HStack {
                    Text("Habit description: ")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                    Text(self.habit.description)
                    .font(.system(size: 20, weight: Font.Weight.bold, design: Font.Design.rounded))
                    .foregroundColor(.gray)
                }
                
        }
            
            Image("\(self.habit.typeOfAction)")
            .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
                
        HStack(spacing: 20){
                VStack{
                    Text("Goal")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                ZStack{
                    Capsule()
                        .frame(width: 100, height: 100, alignment: .center)
                    .shadow(color: .orange, radius: 1, x: 5, y: 5)
                
                    Text("\(self.habit.goal)")
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
                        
                    Text("\(self.habit.steps)")
                    .font(.system(size: 30, weight: Font.Weight.black, design: Font.Design.rounded))
                        .foregroundColor(Color.init(red: 0.239, green: 0.694, blue: 0.557))
                    }
                }
                VStack {
                    Text("Progress:")
                    .font(.system(size: 25, weight: Font.Weight.bold, design: Font.Design.rounded))
                
                ZStack{
                Capsule()
                    .frame(width: 100, height: 100, alignment: .center)
                    .shadow(color: .orange, radius: 1, x: 5, y: 5)
                    Text("\(self.habit.percentCompletion)")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(Color.init(red: 1, green: 0.247, blue: 0.357))
                }
                }
            }
                
            
            Button(action: {
                self.habit.steps += 1
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
        DetailHabitView(habit: HabitItem(name: "Example", description: "This is example", goal: 10, typeOfAction: 0), habits: Habits())
    
    }
}
