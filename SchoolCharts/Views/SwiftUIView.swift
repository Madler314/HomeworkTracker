//
//  SwiftUIView.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 8/20/22.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var bigFatDates = [Date]()
    
    var body: some View {
        MultiDatePicker(anyDays: $bigFatDates)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
