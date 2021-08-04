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
    @AppStorage("showDueDates") private var showDueDates = true
    @AppStorage("allowDatePicker") private var allowDatePicker = true
    
    @State private var name: String = ""
    @State private var isCompleted: Bool = false
    @State private var editMode: Bool = false
    @State private var selectedDate = Date()
    @State var isHover = false
    @State private var showDatePicker = false
    
    var body: some View {
        HStack(alignment:.top, spacing:5) {
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
            VStack(alignment:.leading, spacing:editMode ? 3 : 0) {
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
                if editItem.finishDate != nil && editMode == false && showDueDates {
                    Text("\(editItem.finishDate ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        .foregroundColor(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255))
                }
                // Show Date Picker Button
                HStack {
                    if showDatePicker == false && editMode && allowDatePicker {
                        Button(action: {
                            showDatePicker = true
                        }) {
                            Text("Show Date Picker")
                        }
                        .font(.subheadline)
                        .buttonStyle(PlainButtonStyle())
                        .padding(0)
                    }
                    // Date Picker
                    if editMode && showDatePicker && allowDatePicker {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(CompactDatePickerStyle())
                            .onChange(of: selectedDate, perform: { value in
                                let newDate = selectedDate
                                viewContext.performAndWait {
                                    editItem.finishDate = newDate
                                    try? viewContext.save()
                                }
                            })
                            .onAppear(perform: {
                                self.selectedDate = editItem.finishDate ?? Date()
                            })
                            .scaleEffect(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            .animation(.easeInOut)
                            .font(.system(size:12))
                    }
                    if editMode && editItem.finishDate != nil && allowDatePicker {
                        Divider()
                        Button(action: {
                            viewContext.performAndWait {
                                editItem.finishDate = nil
                                try? viewContext.save()
                                editMode = false
                            }
                        }) {
                            Text("Remove Date")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.subheadline)
                    }
                }
            }
            Spacer()
            if self.isHover || self.editMode {
                Button(action: {
                    editMode.toggle()
                    showDatePicker = false
                }) {
                    Image(systemName: "pencil.circle").font(.system(size:18))
                        .rotationEffect(.degrees(editMode ? 360 : 0))
                        .animation(.easeInOut)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Button(action: {
                withAnimation {
                    viewContext.perform {
                        do {
                            viewContext.delete(editItem)
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
            .buttonStyle(PlainButtonStyle())
        }
        .onHover(perform: { hovering in
            isHover = hovering
        })
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //    formatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:MM a"
    formatter.dateStyle = .short
    formatter.timeStyle = .none
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
