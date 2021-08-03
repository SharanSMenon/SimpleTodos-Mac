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
    
    @State private var name: String = ""
    @State private var isCompleted: Bool = false
    @State private var editMode: Bool = false
    
//    init(editItem: Item) {
//        self.editItem = editItem
//        self._name = State<String>(initialValue: editItem.name!)
//        self._isCompleted = State<Bool>(initialValue: editItem.isCompleted)
//        self._editMode = State<Bool>(initialValue: false)
//        viewContext.performAndWait {
//            try? viewContext.save()
//        }
//    }
//    func initStuff(item: Item) {
//        print(item.name ?? "Untitled Todo")
//        self.name = item.name ?? "Untitled Todo"
//        print(self.name)
//    }
    
    var body: some View {
//        initStuff(item: editItem)
        return HStack {
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
            VStack(alignment:.leading, spacing:0) {
                if editMode == false {
                    Text(editItem.name ?? "Untitled Todo")
                }
                else {
                    TextField("Name", text: $name)
                        .onAppear(perform: {
                            self.name = editItem.name ?? "Untitled todo"
                        })
                        .onChange(of: name, perform: { value in
                            let newName: String = value
                            viewContext.performAndWait {
                                editItem.name = newName
                                try? viewContext.save()
                            }
                        })
                        .textFieldStyle(PlainTextFieldStyle())
                }
                Text("\(editItem.timestamp ?? Date(), formatter: dateFormatter)").font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                editMode.toggle()
            }) {
                if editMode == false {
                    Image(systemName: "pencil.circle").font(.system(size:18))
                } else {
                    Text("Finish")
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //    formatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:MM a"
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct TodoItemRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let item = Item(context: moc)
        item.name = "Name 1"
        return TodoItemRow(editItem: item)
    }
}
