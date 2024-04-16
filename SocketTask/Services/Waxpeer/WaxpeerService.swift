//
//  WaxpeerService.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import Foundation
import Starscream

final class WaxpeerService: SocketService {

    static let shared = WaxpeerService()

    var onStatusChange: (() -> Void)?
    var onReceivedMessage: ((String) -> Void)?

    private var socket: WebSocket
    private let url = URL(string: "wss://waxpeer.com/socket.io/?EIO=4&transport=websocket")!
    var status: SocketStatus = .disconnected

    private var isDisconnectedByUser = false

    init() {
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func connect() {
        isDisconnectedByUser = false
        status = .connecting
        onStatusChange?()
        guard status == .connecting else {
            return
        }

        socket.connect()
    }

    func disconnect() {
        isDisconnectedByUser = true
        socket.disconnect()

        // Обработка преждевременной отмены.
        if status == .connecting {
            status = .disconnected
            onStatusChange?()
        }
    }
}

extension WaxpeerService: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected:
            status = .connected
            subscribeToEvents()

        case .text(let text):
            // TODO: Handle events
            onReceivedMessage?(text)

        case .reconnectSuggested:
            connect()

        case .error(let error):
            print("Error with WebSocket connection: \(error?.localizedDescription ?? "Unknown error")")

        case .peerClosed: 
            handleDisconnect()

        default: break
        }

        self.onStatusChange?()
    }

    private func subscribeToEvents() {
        let events: [WaxpeerEvent] = [.csgo, .new, .removed, .update]
        for event in events {
            subscribeTo(event: event)
        }
    }

    private func subscribeTo(event: WaxpeerEvent) {
        socket.write(string: "42[\"subscribe\",{\"name\":\"\(event.raw)\"}]")
    }

    private func handleDisconnect() {
        if isDisconnectedByUser {
            status = .disconnected
        } else {
            connect()
        }
    }
}
