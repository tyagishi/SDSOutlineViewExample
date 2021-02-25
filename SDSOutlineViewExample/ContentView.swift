//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2021/02/23
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import SwiftUIDebugUtil
import SDSOutlineView

struct ContentView: View {
    @StateObject var dataSource = OutlineSource()
    var body: some View {
        HStack {
            VStack {
                Text("Hello, world!")
                    .background(Color.yellow)
                Button(action: {
                    dataSource.childData[0].append(3)
                }, label: {
                    Text("add new child in first node")
                })
            }
            SDSOutlineView(dataSource: dataSource,
                           columnNames:[NSUserInterfaceItemIdentifier("name"), NSUserInterfaceItemIdentifier("comment")])
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(Color.orange)
                .debugBorder(.red, width: 3)
        }
        .padding()
    }
}

class OutlineSource: OutlineDataSourceDelegateObservable {
    @Published var parentData = [0,1,2]
    @Published var childData = [ Range(10...19).map{$0}, Range(20...29).map{$0}, Range(30...39).map{$0} ]
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let intValue = item as? Int else { return false }
        if intValue < parentData.count { return true }
        return false
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil { return parentData.count }
        guard let intValue = item as? Int,
              intValue < parentData.count else { return 0 }
        return childData[intValue].count
    }
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        guard let intValue = item as? Int else { return nil }
        let cellValue = String(intValue).appending(tableColumn?.identifier.rawValue ?? "")
        return cellValue
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil { return parentData[index] }
        guard let intValue = item as? Int,
              intValue < parentData.count else { return "" }
        return childData[intValue][index]
    }
    
    // for D&D to re-order
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pbItem = NSPasteboardItem()
        if let value = item as? Int {
            if value < 10 {
                // parent
                pbItem.setString(String(value), forType: sdsOutlineDragDropType)
            } else {
                // leaf
                pbItem.setString(String(value), forType: sdsOutlineDragDropType)
            }
        }
        return pbItem
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        var valid = true
        info.enumerateDraggingItems(options: [], for: outlineView, classes: [NSPasteboardItem.self],
                                    searchOptions: [:]) { (dragItem, index, _) in
            if let draggedStr = (dragItem.item as! NSPasteboardItem).string(forType: sdsOutlineDragDropType),
               let draggedInt = Int(draggedStr) {
                print("draggedValue is \(draggedInt)")
                if draggedInt > 9 && item == nil {
                    print("tried to drop leaf on root")
                    valid = false
                }
            }
        }
        if valid == false {
            return []
        }

        return .move
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        if item == nil {
            // drop on root
            print("drop on root")
            return true
        }
        var moveItem = -1
        info.enumerateDraggingItems(options: [], for: outlineView, classes: [NSPasteboardItem.self],
                                    searchOptions: [:]) { (dragItem, index, _) in
            if let draggedStr = (dragItem.item as! NSPasteboardItem).string(forType: sdsOutlineDragDropType),
               let draggedInt = Int(draggedStr) {
                moveItem = draggedInt
            }
        }
        if moveItem < 0 { return false }
        if let rootValue = item as? Int {
            print("drop on \(rootValue)")
            print("leaf index is \(index)")
            print("drop on leaf")

        } else {
            print("drop on root: not implemented")
        }
        childData[0].removeAll(where: {$0 == moveItem})
        childData[1].removeAll(where: {$0 == moveItem})
        childData[2].removeAll(where: {$0 == moveItem})

        return true
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
