//
//  RtcView.swift
//  SwiftUI Quick Example
//
//  Created by shaun on 6/28/22.
//

import Foundation
import SwiftUI
import AgoraRtcKit

struct RemoteRtcView: UIViewRepresentable {
    @EnvironmentObject private var rtcManager: RTCManager
    let uid: UInt

    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        let view  = UIView()
        rtcManager.setupCanvasForRemote(view, uid)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // noop
    }
}

struct LocalRtcView: UIViewRepresentable {
    @EnvironmentObject private var rtcManager: RTCManager
    let uid: UInt

    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        let view  = UIView()
        rtcManager.setupCanvasForLocal(view, uid)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // noop
    }
}
