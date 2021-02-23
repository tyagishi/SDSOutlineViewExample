//
//  SDSOutlineView.swift
//
//  Created by : Tomoaki Yagishita on 2021/02/23
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import AppKit

struct SDSOutlineView: NSViewRepresentable {
//    associatedtype dataSource = NSOutlineViewDataSource
    
    @ObservedObject var dataSource:OutlineSource
    //var dataSource: OutlineSource
    let columnNames:[NSUserInterfaceItemIdentifier]
    var delegate: NSOutlineViewDelegate? = nil
    
    internal init(dataSource: OutlineSource, columnNames: [NSUserInterfaceItemIdentifier], delegate: NSOutlineViewDelegate? = nil) {
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

