//
//  ContentView.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var itemName: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @State var showSettings: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            if !showSettings {
                TodoListView()
            } else {
                SettingsView()
            }
            Spacer()
            HStack(alignment:.top) {
                Button(action: {
                    showSettings.toggle()
                }) {
                    Image(systemName: showSettings ? "return" : "gear")
                        .font(.system(size:20))
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }.frame(width:.infinity)
            .padding()
        }
        .frame(height:400)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
