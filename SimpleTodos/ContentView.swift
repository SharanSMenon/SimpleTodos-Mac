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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Item Name", text: $itemName)
                    .textFieldStyle(PlainTextFieldStyle())
                Button(action: {
                    addItem()
                }) {
                    Text("Add Item")
                }
            }
            List {
                ForEach(items) { item in
                    
                    TodoItemRow(editItem: item)
                }
                .onDelete(perform: deleteItems)
            }        }
            .padding()
    }
    
    private func addItem() {
        withAnimation(.easeIn) {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            if !itemName.isEmpty {
                newItem.name = itemName
            }
            itemName = ""
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation(.easeOut) {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
