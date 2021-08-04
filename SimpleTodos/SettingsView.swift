//
//  SettingsView.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/4/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showCompleted") private var completedOnly = false
    @AppStorage("showDueDates") private var showDueDates = true
    @AppStorage("allowDatePicker") private var allowDatePicker = true
    @AppStorage("defaultTodoName") private var defaultTodoName = "Untitled Todo"
    var body: some View {
        VStack(alignment:.leading) {
            Form  {
                Section {
                    Toggle("Show Completed Only", isOn: $completedOnly)
                    Toggle("Show Due Dates", isOn: $showDueDates)
                    Toggle("Allow Date Picker", isOn: $allowDatePicker)
                }
                Section {
                    VStack {
                        Text("Default Todo Name").bold()
                        TextField("Default Todo Name", text:$defaultTodoName)
                    }
                }
            }
        }
        .padding()
        .frame(width:400, height:.infinity)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
