//
//  TodoListView.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/4/21.
//

import SwiftUI

struct TodoListView: View {
    @State var itemName: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("showCompleted") private var showCompleted = false
    @AppStorage("defaultTodoName") private var defaultTodoName = "Untitled Todo"
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        let filteredItems = items.filter {item in (!showCompleted || item.isCompleted) }
        VStack {
            HStack {
                TextField("Enter Item Name", text: $itemName)
                    .textFieldStyle(PlainTextFieldStyle())
                Button(action: {
                    if (itemName.trimmingCharacters(in: .whitespaces) != "") {
                        addItem()
                    } else {
                        itemName = defaultTodoName
                        addItem()
                    }
                }) {
                    Image(systemName: "plus").font(.system(size:18))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.init(top: 20, leading: 20, bottom: 10, trailing: 18))
            Divider()
            if filteredItems.count == 0 {
                Spacer()
                    .frame(height:150)
                if items.count > 0 {
                    Text("There are no completed items.")
                } else {
                    Text("Click + to add a new item")
                }
            } else {
                List {
                    ForEach(filteredItems, id: \.id) {item in
                        HStack {
                            TodoItemRow(editItem: item)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
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

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
