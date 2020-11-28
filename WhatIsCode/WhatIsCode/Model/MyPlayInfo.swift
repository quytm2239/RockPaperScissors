//
//  PlayerInfo.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/27/20.
//

import Foundation

class MyPlayInfo {
    var name: String {
        get { return _name }
        set {
            if isUpdatedName { return }
            _name = newValue
        }
    }
    
    private var _name: String = ""
    var isUpdatedName = false
    var lastChoice = Choice.paper
    
    func updateName(_ name: String) {
        if isUpdatedName { return }
        isUpdatedName = true
        _name = name
    }
    
    static let shared = MyPlayInfo()
}
