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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
