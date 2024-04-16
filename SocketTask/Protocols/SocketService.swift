//
//  SocketService.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import Foundation

protocol SocketService {
    var onStatusChange: (() -> Void)? { get set }
    var onReceivedMessage: ((String) -> Void)? { get set }

    var status: SocketStatus { get }

    func connect()
    func disconnect()
}
