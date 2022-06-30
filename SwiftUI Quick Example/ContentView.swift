//
//  ContentView.swift
//  SwiftUI Quick Example
//
//  Created by shaun on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rtcManager: RTCManager
    var body: some View {
        GeometryReader { geo in
            let smallest = min(geo.size.height, geo.size.width) - 10
            let modifier = RtcViewModifier(dimension: smallest)
            List {
                if rtcManager.myUid != 0 {
                    LocalRtcView(uid: rtcManager.myUid)
                        .modifier(modifier)
                }

                ForEach(rtcManager.sortedUids, id: \.self) { uid in
                    RemoteRtcView(uid: uid)
                        .modifier(modifier)
                }
            }
            .listStyle(PlainListStyle())
            .listRowSeparator(.hidden)
        }
    }
}

private struct RtcViewModifier: ViewModifier {
    let dimension: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: dimension, height: dimension, alignment: .center)
            .listRowInsets(.init())
            .padding(5)

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
