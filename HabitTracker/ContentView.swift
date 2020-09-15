//
//  ContentView.swift
//  HabitTracker
//
//  Created by DeNNiO   G on 21.07.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ImageTabModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
            .shadow(color: .black, radius: 1, x: 3, y: 3)
    }
}

struct TextTabModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .black, design: .rounded))
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewRouter = ViewRouter()
    @Environment(\.managedObjectContext) var moc
    @State private var habitViewOpen = false
    @State private var showStatusBar = true

    init() {
       // UITableView.appearance().allowsSelection = false
               UITableViewCell.appearance().selectionStyle = .none
        UINavigationBar.appearance().barTintColor = UIColor(named: "tabBarColor")
      
        UITableView.appearance().separatorColor = .clear
        UISwitch.appearance().thumbTintColor = UIColor(named: "colorSet1")
        UISwitch.appearance().onTintColor = UIColor(named: "toggleColor")
        //attributes for title color and font
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "titleColor"),
            NSAttributedString.Key.font: UIFont(name: "Futura-CondensedExtraBold", size: 20)!
        ]
        //Chalkduster, Futura-CondensedExtraBold
        UINavigationBar.appearance().titleTextAttributes = attrs as [NSAttributedString.Key : Any]
    }

        var body: some View {
            ZStack {
                self.colorScheme == .light ? barColorLight : barColorDark
                GeometryReader { geo in
                        VStack {
                            if self.viewRouter.currentView == "active" {
                                MainHabitView(predicateType: .active)
                            } else if self.viewRouter.currentView == "completed" {
                                MainHabitView(predicateType: .completed)
                            } else if self.viewRouter.currentView == "statistic" {
                                StatsView()
                            }
                            Spacer()
                            
                            HStack {
                                VStack {
                                    Image("active3")
                                        .resizable()
                                        .modifier(ImageTabModifier())
                                        .onTapGesture {
                                            self.viewRouter.currentView = "active"
                                        }
                                    Text("Active habits")
                                        .modifier(TextTabModifier())
                                        .foregroundColor(self.viewRouter.currentView == "active" ? (self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)  : (self.colorScheme == .light ? tabBarTextPrimaryLightColor : tabBarTextPrimaryDarkColor))
                                    Spacer()
                                }
                                    .frame(width: geo.size.width/3, height: 75)
                            
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(self.viewRouter.currentView == "statistic" ? (self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)  : (self.colorScheme == .light ? tabBarTextPrimaryLightColor : tabBarTextPrimaryDarkColor))
                                            .shadow(color: .black, radius: 1, x: 3, y: 3)
                                        Image("graph")
                                            .resizable()
                                            .modifier(ImageTabModifier())
                                            .padding(20)
                                            .frame(width: geo.size.width/3, height: 75)
                                            .onTapGesture {
                                                self.viewRouter.currentView = "statistic"
                                            }
                                    }
                                        .offset(y: geo.size.height/16)
                                    Image("add2")
                                        .resizable()
                                        .modifier(ImageTabModifier())
                                        .frame(width: 75, height: 75)
                                        .rotationEffect(Angle(degrees: self.habitViewOpen ? 90 : 0))
                                }
                                    .offset(y: -geo.size.height/15)
                                    .onTapGesture {
                                        self.habitViewOpen.toggle()
                                    }
                            
                                VStack {
                                    Image("completed3")
                                        .resizable()
                                        .modifier(ImageTabModifier())
                                        .onTapGesture {
                                            self.viewRouter.currentView = "completed"
                                        }
                                    Text("Completed habits")
                                        .padding(.leading, -30)
                                        .modifier(TextTabModifier())
                                        .foregroundColor(self.viewRouter.currentView == "completed" ? (self.colorScheme == .light ? tabBarTextSecondaryLightColor : tabBarTextSecondaryDarkColor)  : (self.colorScheme == .light ? tabBarTextPrimaryLightColor : tabBarTextPrimaryDarkColor))
                                    Spacer()
                                }
                                    .frame(width: geo.size.width/3, height: 75)
                            
                            }
                                .frame(width: geo.size.width, height: geo.size.height/10)
                                .background(self.colorScheme == .light ? barColorLight : barColorDark)
                        }
                    }
                }
                    .statusBar(hidden: true)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .edgesIgnoringSafeArea(.bottom)
                    .sheet(isPresented: $habitViewOpen) {
                        HabitView().environment(\.managedObjectContext, self.moc)
                    }
                //color and font of nav bar buttons
                    .accentColor(colorScheme == .light ? tabBarTextPrimaryLightColor  : tabBarTextPrimaryDarkColor)
                    .font(.system(size: 20, weight: .black, design: .rounded))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
