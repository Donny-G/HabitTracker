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
        Form {
            if notificationIsEnabled == true {
            //Default
                HStack {
                Text("Notification")
                Image(systemName: "checkmark.rectangle")
                }
            
                HStack {
                    Text("Type of notification")
                    Image(systemName: typeOfNotification == TypeOfNotifications.def.rawValue ? "gear" : "hand.raised.fill")
                }
        //manual
                if typeOfNotification != TypeOfNotifications.def.rawValue {
                    HStack {
                        Image(systemName: typeOfManualNotification == TypesOfManualNotifications.delay.rawValue ? "timer" : "alarm")
                        if delayInMinutes != "" || delayInHours != "" {
                            Text(delayInMinutes != "" ? delayInMinutes : delayInHours)
                        } else {
                            Text(timeForNtfn)
                        }
                    }
                
                    if daysForNtfn != "" {
                        HStack {
                            Image(systemName: "calendar")
                            Text(daysForNtfn)
                        }
                    }
                
                    HStack {
                        Text("Is continues")
                        Image(systemName: isNtfnContinues ? "checkmark.rectangle" : "rectangle")
                    }
                }
            } else {
                HStack {
                    Text("Notification")
                    Image(systemName: "rectangle")
                }
           
                if notificationIsEnabled == false && showSetButton == true {
                    Button(action: {
                        self.showNotificationSetView = true
                    }) {
                        Text("Set new notification")
                    }
                }
            }
        }
    }
}


