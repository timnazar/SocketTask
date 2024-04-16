//
//  ContentViewModel.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {
    var socketService: SocketService
    @Published var receivedMessages: [String] = []
    @Published var buttonBackgroundColor = Color.gray
    @Published var buttonImage = ""
    @Published var buttonTitle = ""
    @Published var instructionsText = ""

    init(socketService: SocketService) {
        self.socketService = socketService
        updateUI()
        self.socketService.onStatusChange = { [weak self] in
            self?.updateUI()
        }
        self.socketService.onReceivedMessage = { [weak self] message in
            self?.receivedMessages.append(message)
        }
    }

    func handleTap() {
        switch socketService.status {
        case .connected: socketService.disconnect()
        case .disconnected: socketService.connect()
        case .connecting: socketService.disconnect()
        }
    }

    private func updateUI() {
        updateTexts()
        updateButtonColor()
        updateButtonImage()
        updateReceivedMessages()
    }

    private func updateTexts() {
        switch socketService.status {
        case .connected:
            buttonTitle = "Connected"
            instructionsText = "Press the button to disconnect from the server"

        case .disconnected:
            buttonTitle = "Disconnected"
            instructionsText = "Press the button to connect to the server"

        case .connecting:
            buttonTitle = "Connecting"
            instructionsText = "Press the button to cancel"
        }
    }

    private func updateButtonColor() {
        switch socketService.status {
        case .connected: buttonBackgroundColor = .green
        case .disconnected: buttonBackgroundColor = .gray
        case .connecting: buttonBackgroundColor = .orange.opacity(0.6)
        }
    }

    private func updateButtonImage() {
        switch socketService.status {
        case .connected: buttonImage = "cable.connector"
        case .disconnected: buttonImage = "cable.connector.slash"
        case .connecting: buttonImage = "circle.hexagonpath.fill"
        }
    }

    private func updateReceivedMessages() {
        if socketService.status == .disconnected {
            receivedMessages = []
        }
    }
}
