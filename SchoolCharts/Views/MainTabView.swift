//
//  TabView.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/23/22.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var viewModel = TaskViewModel()
    
    @State var isPresenting: Bool = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                
            CalendarHome()
                .tabItem { Label("Calendar", systemImage: "calendar") }
        }
        .environmentObject(viewModel)
        .onAppear {
            //viewModel.loadTasks()
        }
        .onDisappear {
            //viewModel.saveTasks()
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(TaskViewModel())
    }
}
