//
//  PlayerTurnInfo.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/27/20.
//

import Foundation

enum Choice: String {
    case none = "None", rock = "Rock", paper = "Paper", scissors = "Scissors"
}

struct PlayerTurnInfo: Codable {
    var choice = ""
    var name = ""
    var state = ""
}

extension PlayerTurnInfo {
    var displayChoice: Choice {
        return Choice(rawValue: self.choice) ?? Choice.none
    }
}
