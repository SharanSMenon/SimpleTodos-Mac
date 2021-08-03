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
                    Image(systemName: "plus").font(.system(size:18))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.init(top: 20, leading: 20, bottom: 10, trailing: 18))
            List {
                ForEach(items, id: \.id) {item in
                    HStack {
                        TodoItemRow(editItem: item)
                        Button(action: {
                            withAnimation {
                                viewContext.perform {
                                    do {
                                        viewContext.delete(item)
                                        try viewContext.save()
                                    } catch {
                                        viewContext.rollback()
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "minus.circle").font(.system(size:18))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
        }
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem: Item = Item(context: viewContext)
            let timestamp: Date = Date()
            newItem.timestamp = timestamp
            newItem.name = self.itemName
            newItem.id = UUID()
            do {
                try viewContext.save()
                self.itemName = ""
            } catch {
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
