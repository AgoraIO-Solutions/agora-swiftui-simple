//
//  RTCManager.swift
//  SwiftUI Quick Example
//
//  Created by shaun on 6/28/22.
//

import Foundation
import OSLog
import SwiftUI
import AgoraRtcKit

class RTCManager: NSObject, ObservableObject {
    private let logger = Logger(subsystem: "io.agora.SwiftUI-Quick-Example", category: "RTCManager")
    private(set) var engine: AgoraRtcEngineKit!
    private var uids: Set<UInt> = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var myUid: UInt = 0 {
        didSet {
            self.objectWillChange.send()
        }
    }
    var sortedUids: [UInt] {
        return uids.sorted() // consistently get the same order of uids
    }

    override init() {
        super.init()
        do {
            engine = .sharedEngine(withAppId: try Config.value(for: "AGORA_APP_ID"), delegate: self)
        } catch {
            fatalError("Error initializing the engine \(error)")
        }
        engine.disableAudio()
        engine.enableVideo()
        let status = engine.joinChannel(byToken: .none, channelId: "test", info: .none, uid: myUid) { _, uid, _ in
            self.logger.info("Join success called, joined as \(uid)")
            self.myUid = uid
        }

        if status != 0 {
            logger.error("Error joining \(status)")
        }

    }
}

extension RTCManager {
    func setupCanvasForRemote(_ uiView: UIView, _ uid: UInt) {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        canvas.view = uiView
        engine.setupRemoteVideo(canvas)
    }

    func setupCanvasForLocal(_ uiView: UIView, _ uid: UInt) {
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.renderMode = .hidden
        canvas.view = uiView
        engine.setupLocalVideo(canvas)
    }
}

extension RTCManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        logger.error("Error \(errorCode.rawValue)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        logger.info("Joined \(channel) as uid \(uid)")
        myUid = uid
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        logger.info("other user joined as \(uid)")
        uids.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        logger.info("other user left with \(uid)")
        uids.remove(uid)
    }
}
