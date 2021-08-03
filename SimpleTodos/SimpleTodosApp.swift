//
//  SimpleTodosApp.swift
//  SimpleTodos
//
//  Created by Sharan Sajiv Menon on 8/2/21.
//

import SwiftUI

@main
struct SimpleTodosApp: App {
    let persistenceController = PersistenceController.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
            WindowGroup{
                EmptyView()
                    .frame(width:0, height:0)
            }
        }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let persistenceController = PersistenceController.shared
        let contentView = ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 390)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "Checklist")
            button.action = #selector(togglePopover(_:))
        }
        
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
                self.popover.contentViewController?.view.window?.becomeKey()
                
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
