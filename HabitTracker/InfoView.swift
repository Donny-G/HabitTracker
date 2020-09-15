//
//  InfoView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageInfoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80)
            .scaledToFit()
            .shadow(color: .black, radius: 1, x: 3, y: 3)
            .padding(.leading, 10)
    }
}

struct TextHeadLineModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30, weight: .black, design: .rounded))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .foregroundColor(colorScheme == .light ? firstTextColorLight : firstTextColorDark)
            .shadow(color: .black, radius: 1, x: 2, y: 2)
    }
}

struct TextDefModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .black, design: .rounded))
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(colorScheme == .light ? thirdTextColorLight : thirdTextColorDark)
            .shadow(color: .black, radius: 1, x: 1, y: 1)
    }
}

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text("Main View & Habit View")
                            .modifier(TextHeadLineModifier())
                    
                        Group {
                            HStack {
                                Image("add2")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Press button to add new habit")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("activeForInfo")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Active habits")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("completedForInfo")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Completed habits")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("statsForInfo")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Statistics info")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("tap")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("By long tapping on habit you can add one step to your progress")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("tapButton")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Press button to mark new step")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("delete")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Delete current habit")
                                    .modifier(TextDefModifier())
                            }
                        }
            
                        Spacer()
            
                        Text("New habit")
                            .modifier(TextHeadLineModifier())
            
                        Group {
                            HStack {
                                Image("setNotificationOn")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Enable current notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("setNotificationOff")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Disable current notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("typesForInfo")
                                    .resizable()
                                    .frame(width: 80, height: 20)
                                    .scaledToFit()
                                    .shadow(color: .black, radius: 1, x: 3, y: 3)
                                    .padding(.leading, 10)
                            
                                Text("Choose type of activity")
                                    .modifier(TextDefModifier())
                                   
                            }
                            HStack {
                                Image("gallery")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("You can choose picture for habit from gallery")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("photo")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("You can take picture for habit from camera")
                                    .modifier(TextDefModifier())
                            }
                        }
            
                        Spacer()
            
                        Text("Notifications")
                            .modifier(TextHeadLineModifier())
                
                        Group {
                            HStack() {
                                Image("notificationIsOn")
                                  .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Notification is enabled")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("notificationIsOff")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Notification is disabled")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("auto")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("You set default notification at 9:00 everyday")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("manual")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("You set manual notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("timer2")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Timer countdown")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("alarm")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Time for notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("continues")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Continues notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("notContinues")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Not continues notification")
                                    .modifier(TextDefModifier())
                            }
                            HStack {
                                Image("daysweek")
                                    .resizable()
                                    .modifier(ImageInfoModifier())
                                Text("Notification on days of week")
                                    .modifier(TextDefModifier())
                            }
                        }
                    }
                }
            }   .navigationBarTitle("i", displayMode: .inline)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(self.colorScheme == .light ? tabBarTextPrimaryLightColor  : tabBarTextPrimaryDarkColor)
                })
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
