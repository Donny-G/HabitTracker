//
//  NotificationsInfoView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 04.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct NotificationsInfoView: View {
    @Binding var notificationIsEnabled: Bool
    @Binding var typeOfNotification: String
    @Binding var typeOfManualNotification: String
    @Binding var delayInMinutes: String
    @Binding var delayInHours: String
    @Binding var timeForNtfn: String
    @Binding var daysForNtfn: String
    @Binding var isNtfnContinues: Bool
    @Binding var idForNtfn: String
    @Binding var showSetButton: Bool
    @Binding var showNotificationSetView: Bool
    

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if notificationIsEnabled == true {
                    //Default
                    Image("notificationIsOn")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
            
                    Image(typeOfNotification == TypeOfNotifications.def.rawValue ? "auto" : "manual")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                    //manual
                    if typeOfNotification != TypeOfNotifications.def.rawValue {
                        VStack {
                            Image(typeOfManualNotification == TypesOfManualNotifications.delay.rawValue ? "timer2" : "alarm")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                            if delayInMinutes != "" || delayInHours != "" {
                                Text(delayInMinutes != "" ? delayInMinutes : delayInHours)
                            } else {
                                Text(timeForNtfn)
                            }
                        }
                
                        if daysForNtfn != "" {
                            VStack {
                                Image("daysweek")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                Text(daysForNtfn)
                            }
                        }
                            Image(isNtfnContinues ? "continues" : "notContinues")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                    }
                } else {
                        Image("notificationIsOff")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
           
                
                
            }
        }
            if notificationIsEnabled == false && showSetButton == true {
                Button(action: {
                    self.showNotificationSetView = true
                }) {
                    Image("setNotificationOn")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    Text("Set new notification")
                }
            }
        }
        
    }
}


