//
//  StringExtension.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/28/20.
//

import Foundation

extension Array where Element == String {
    func getJoined(_ separator: String = ", ") -> String {
        var joinedString = ""
        var index = 0
        let lastIndex = self.count - 1
        self.forEach({ (item) in
            if !item.isEmpty {
                joinedString.append(item)
                if index < lastIndex { joinedString.append(separator) }
            }
            index += 1
        })
        return joinedString
    }
}
