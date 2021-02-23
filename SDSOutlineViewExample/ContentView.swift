//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2021/02/23
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import SwiftUIDebugUtil

struct ContentView: View {
    @StateObject var dataSource = OutlineSource()
    var body: some View {
        HStack {
            Text("Hello, world!")
                .background(Color.yellow)
            Button(action: {
                dataSource.childData[0].append(3)
            }, label: {
                Text("add new child")
            })
            SDSOutlineView(dataSource: dataSource,
                           columnNames:[NSUserInterfaceItemIdentifier("name"), NSUserInterfaceItemIdentifier("comment")],
                           delegate: nil)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(Color.orange)
                .debugBorder(.red, width: 3)
        }
        .padding()
    }
}

class AnyOutlineSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
}


class OutlineSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate, ObservableObject {
//class OutlineSource: AnyOutlineSource, ObservedObject {
    let parentData = [0,1,2]
    @Published var childData = [
        Range(10...19).map{$0},
        Range(20...29).map{$0},
        Range(30...39).map{$0}
    ]
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let intValue = item as? Int else { return false }
        if intValue < parentData.count { return true }
        return false
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return parentData.count
        }
        return childData[0].count
    }
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        guard let intValue = item as? Int else { return nil }
        let cellValue = String(intValue).appending(tableColumn?.identifier.rawValue ?? "")
        return cellValue
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return parentData[index]
        }
        guard let intValue = item as? Int,
              intValue < parentData.count else { return "" }
        return childData[intValue][index]
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
