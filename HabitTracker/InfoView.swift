//
//  InfoView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Main View & Habit View")
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image("add1")
                        .resizable()
                        .scaledToFit()
                    Text("Press button to add new habit")
                }
                HStack {
                    Image("activeForInfo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Active habits")
                }
                
                HStack {
                    Image("completedForInfo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Completed habits")
                }
                HStack {
                    Image("statsForInfo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Statistics info")
                }
                HStack {
                    Image("tap")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("By long tapping on habit you can add one step to your progress")
                }
                
                HStack {
                    Image("tapButton")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Press button to mark new step")
                }
                HStack {
                    Image("delete")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Delete current habit")
                }
            }
            
            Spacer()
            
            Text("New habit")
            
            VStack(alignment: .leading) {
                
                HStack {
                    Image("setNotificationOn")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Enable current notification")
                }
                HStack {
                    Image("setNotificationOff")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Disable current notification")
                }
                HStack {
                    Image("typesForInfo")
                        .resizable()
                        .scaledToFit()
                    Text("Choose type of activity")
                }
                HStack {
                    Image("gallery")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("You can choose picture for habit from gallery")
                }
                HStack {
                    Image("photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("You can take picture for habit from camera")
                }
            }
            
            Spacer()
            
            Text("Notifications")
                
            VStack(alignment: .leading) {
                
                HStack {
                    Image("notificationIsOn")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                    Text("Notification is enabled")
                }
            
                HStack {
                    Image("notificationIsOff")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Notification is disabled")
                }
                
                HStack {
                    Image("auto")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("You set default notification at 9:00 everyday")
                }
                
                HStack {
                    Image("manual")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("You set manual notification")
                }
                
                HStack {
                    Image("timer2")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Timer countdown")
                }
                
                HStack {
                    Image("alarm")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Time for notification")
                }
                
                HStack {
                    Image("continues")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Continues notification")
                }
                
                HStack {
                    Image("notContinues")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Not continues notification")
                }
                
                HStack {
                    Image("daysweek")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                    Text("Notification on days of week")
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
