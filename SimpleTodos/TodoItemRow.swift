//
//  TodoItemRow.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/3/21.
//

import SwiftUI

struct TodoItemRow: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var editItem: Item
    
    @State private var name: String
    @State private var isCompleted: Bool
    
    init(editItem: Item) {
        self.editItem = editItem
        self._name = State<String>(initialValue: editItem.name!)
        self._isCompleted = State<Bool>(initialValue: editItem.isCompleted)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    let newStatus: Bool = !editItem.isCompleted
                    
                    viewContext.performAndWait {
                        editItem.isCompleted = newStatus
                        try? viewContext.save()
                    }
                }
            }) {
                Image(systemName: editItem.isCompleted ? "checkmark.circle.fill" :"circle")
                    .font(.system(size: 18))
                    .foregroundColor(editItem.isCompleted ? .green : .blue)
            }
            .buttonStyle(PlainButtonStyle())
            TextField("Name", text: $name)
                .onChange(of: name, perform: { value in
                    let newName: String = value
                    viewContext.performAndWait {
                        editItem.name = newName
                        try? viewContext.save()
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let item = Item(context: moc)
        item.name = "Name 1"
        return TodoItemRow(editItem: item)
    }
}
