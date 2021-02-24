//
//  SDSOutlineView.swift
//
//  Created by : Tomoaki Yagishita on 2021/02/23
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import AppKit

protocol OutlineNode {
    var isRoot:Bool { get }
    var isExpandable:Bool { get }
    var children:[OutlineNode] { get }
}

typealias AnyOutlineDataSource = NSObject & NSOutlineViewDataSource & ObservableObject
//protocol AnyOutlineDataSource:NSObject, NSOutlineViewDataSource, ObservableObject {

class OutlineSource: AnyOutlineDataSource {
//class OutlineSource: AnyOutlineSource, ObservedObject {
    let parentData = [0,1,2]
    @Published var childData = [ Range(10...19).map{$0}, Range(20...29).map{$0}, Range(30...39).map{$0} ]
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let intValue = item as? Int else { return false }
        if intValue < parentData.count { return true }
        return false
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil { return parentData.count }
        return childData[0].count
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
}

struct SDSOutlineView<DataSource>: NSViewRepresentable where DataSource:AnyOutlineDataSource{
//    associatedtype dataSource = NSOutlineViewDataSource
    
    @ObservedObject var dataSource:DataSource
    //var dataSource: OutlineSource
    let columnNames:[NSUserInterfaceItemIdentifier]
    var delegate: NSOutlineViewDelegate? = nil
    
    internal init(dataSource: DataSource, columnNames: [NSUserInterfaceItemIdentifier], delegate: NSOutlineViewDelegate? = nil) {
        self.dataSource = dataSource
        self.columnNames = columnNames
        self.delegate = delegate
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let outlineView = NSOutlineView()
        scrollView.documentView = outlineView
        outlineView.usesAlternatingRowBackgroundColors = true
        for columnName in columnNames {
            let newColumn = NSTableColumn(identifier: columnName)
            newColumn.title = columnName.rawValue
            outlineView.addTableColumn(newColumn)
        }

        outlineView.dataSource = dataSource
        if let delegate = delegate {
            outlineView.delegate = delegate
        }
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        print("updateNSView is called")
        guard let outlineView = nsView.documentView as? NSOutlineView else { return }
        outlineView.reloadData()
    }
    
    typealias NSViewType = NSScrollView
}

