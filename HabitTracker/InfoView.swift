//
//  InfoView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 25.08.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageInfoModifier: ViewModifier {
    var geo: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: geo, height: 80)
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
    var geo: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .black, design: .rounded))
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(colorScheme == .light ? thirdTextColorLight : thirdTextColorDark)
            .shadow(color: .black, radius: 1, x: 1, y: 1)
            .frame(width: geo, alignment: .leading)
            .padding(.leading, 10)
    }
}

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                self.colorScheme == .light ? mainSpaceColorLight : mainSpaceColorDark
                GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                        
                            Text("Main View & Habit View")
                                .modifier(TextHeadLineModifier())
                    
                            Group {
                                HStack {
                                    Image("add2")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                               
                                    Text("Press button to add new habit")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("activeForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Active habits")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("completedForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Completed habits")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("statsForInfo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Statistics info")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("tap")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("By long tapping on habit you can add one step to your progress")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("tapButton")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Press button to mark new step")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("delete")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Delete current habit")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                            }
            
                            Spacer()
            
                            Text("New habit")
                                .modifier(TextHeadLineModifier())
            
                            Group {
                                HStack {
                                    Image("setNotificationOn")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Enable current notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("setNotificationOff")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Disable current notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("typesForInfo")
                                        .resizable()
                                        .frame(width: geo.size.width * 0.2, height: 20)
                                        .scaledToFit()
                                        .shadow(color: .black, radius: 1, x: 3, y: 3)
                                        .padding(.leading, 10)
                            
                                    Text("Choose type of activity")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                   
                                }
                                HStack {
                                    Image("gallery")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("You can choose picture for habit from gallery")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("photo")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("You can take picture for habit from camera")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                            }
            
                            Spacer()
            
                            Text("Notifications")
                                .modifier(TextHeadLineModifier())
                
                            Group {
                                HStack() {
                                    Image("notificationIsOn")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Notification is enabled")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("notificationIsOff")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Notification is disabled")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("auto")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("You set default notification at 9:00 everyday")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("manual")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("You set manual notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("timer2")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Timer countdown")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("alarm")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Time for notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("continues")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Continues notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("notContinues")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Not continues notification")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
                                HStack {
                                    Image("daysweek")
                                        .resizable()
                                        .modifier(ImageInfoModifier(geo: geo.size.width * 0.2))
                                    Text("Notification on days of week")
                                        .modifier(TextDefModifier(geo: geo.size.width * 0.7))
                                }
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
