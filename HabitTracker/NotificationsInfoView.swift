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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            colorScheme == .light ? barColorLight : blue
            HStack {
                if notificationIsEnabled == true {
                    //Default
                    Image("notificationIsOn")
                        .resizable()
                        .modifier(CurrentImageModifier(width: 50, height: 50))
            
                    Image(typeOfNotification == TypeOfNotifications.def.rawValue ? "auto" : "manual")
                        .resizable()
                        .modifier(CurrentImageModifier(width: 50, height: 50))
                    //manual
                    if typeOfNotification != TypeOfNotifications.def.rawValue {
                        VStack {
                            Image(typeOfManualNotification == TypesOfManualNotifications.delay.rawValue ? "timer2" : "alarm")
                                .resizable()
                                .modifier(CurrentImageModifier(width: 50, height: 50))
                            if delayInMinutes != "" || delayInHours != "" {
                                Text(delayInMinutes != "" ? delayInMinutes : delayInHours)
                                    .modifier(MainTextNotificationViewModifier(size: 15))
                                    .foregroundColor(colorScheme == .light ? orange : firstTextColorLight)
                            } else {
                                Text(timeForNtfn)
                                    .modifier(MainTextNotificationViewModifier(size: 15))
                                    .foregroundColor(colorScheme == .light ? orange : firstTextColorLight)
                            }
                        }
                
                        if daysForNtfn != "" {
                            VStack {
                                Image("daysweek")
                                    .resizable()
                                    .modifier(CurrentImageModifier(width: 50, height: 50))
                                    .foregroundColor(colorScheme == .light ? orange : firstTextColorLight)
                                Text(daysForNtfn)
                                    .modifier(MainTextNotificationViewModifier(size: 12))
                                    .foregroundColor(colorScheme == .light ? orange : firstTextColorLight)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                            Image(isNtfnContinues ? "continues" : "notContinues")
                                .resizable()
                                .modifier(CurrentImageModifier(width: 50, height: 50))
                    }
                } else {
                        Image("notificationIsOff")
                            .resizable()
                            .modifier(CurrentImageModifier(width: 50, height: 50))
                }
            }
        }
            .cornerRadius(20)
            .shadow(color: .black, radius: 1, x: 5, y: 5)
    }
}


