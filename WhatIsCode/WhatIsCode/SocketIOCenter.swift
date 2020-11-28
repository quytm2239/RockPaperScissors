//
//  SocketIOCenter.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/28/20.
//

import SocketIO

enum EventName: String {
    case move = "move",
         countDown = "count_down",
         joinGame = "join_game",
         result = "result",
         userLeft = "user_left",
         yourInfo = "your_info"
}

protocol SocketIOCenterDelegate: class {
    func onEvent(name: EventName, data: [Any]?)
    func onConnectivityChanged(connected: Bool)
}

struct CustomData: SocketData {
    let msg: String
    func socketRepresentation() -> SocketData {
        return msg
    }
}

class SocketIOCenter {
    // MARK: - Properties
    public static let shared = SocketIOCenter()
//    static let baseUrl = "https://strange-chat.herokuapp.com"
    static let baseUrl = "https://hammer-bag-scissors.herokuapp.com/"

    private let manager: SocketManager
    private let socket: SocketIOClient
    private weak var delegate: SocketIOCenterDelegate?

    // MARK: - Constructor
    private init() {
        manager = SocketManager(socketURL: URL(string: SocketIOCenter.baseUrl)!, config: [.log(false), .compress, .reconnects(true)])
        socket = manager.defaultSocket
        setupEventHandler()
    }

    // MARK: - Basic methods
    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
        delegate?.onConnectivityChanged(connected: false)
    }

    func setDelegate(_ delegate: SocketIOCenterDelegate) {
        self.delegate = delegate
    }

    private func setupEventHandler() {
        socket.on(clientEvent: .connect) {[weak self] _, _ in
            print("Connected to socket server")
            self?.delegate?.onConnectivityChanged(connected: true)
            self?.sendJoin(MyPlayInfo.shared.name)
        }
        socket.on(clientEvent: .error) {[weak self] data, _ in
            self?.delegate?.onConnectivityChanged(connected: false)
            print(data)
        }
        socket.onAny { [weak self](anyEvent) in
            guard let eventName = EventName.init(rawValue: anyEvent.event) else { return }
            DispatchQueue.main.async {
                self?.delegate?.onEvent(name: eventName, data: anyEvent.items)
            }
        }
    }

    func sendMove(_ choice: Choice) {
        socket.emit(EventName.move.rawValue, choice.rawValue)
    }
    
    private func sendJoin(_ name: String) {
        socket.emit(EventName.joinGame.rawValue, name)
    }
}
