//
//  PlayerChoiceView.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/27/20.
//

import UIKit

class PlayerChoiceView: UIView {
    @IBOutlet weak var labelPlayerName: UILabel!
    @IBOutlet weak var labelPlayerChoice: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    func updateData(_ data:  PlayerTurnInfo) {
        labelPlayerName.text = data.name
        if data.name == MyPlayInfo.shared.name {
            labelPlayerName.text = "\(data.name) - You"
        }
        labelPlayerChoice.text = data.choice
        if let choice = Choice(rawValue: data.choice) {
            switch choice {
            case .paper:
                icon.image = UIImage(named: "icon_paper")
            case .scissors:
                icon.image = UIImage(named: "icon_scissors")
            case .rock:
                icon.image = UIImage(named: "icon_rock")
            case .none:
                icon.image = UIImage()
            }
        }
        backgroundColor = data.state == "Win"
            ? UIColor.green.withAlphaComponent(0.4)
            : (data.state == "Lose"
                ? UIColor.red.withAlphaComponent(0.4)
                : UIColor.white)
    }
}
