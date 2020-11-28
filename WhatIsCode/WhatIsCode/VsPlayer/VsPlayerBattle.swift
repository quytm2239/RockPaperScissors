//
//  VsPlayerBattle.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/28/20.
//

import UIKit

class VsPlayerBattle: UIViewController {
    
    @IBOutlet weak var arena: UIStackView!
    @IBOutlet weak var labelWinner: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelJoined: UILabel!
    @IBOutlet weak var buttonRock: UIButton!
    @IBOutlet weak var buttonPaper: UIButton!
    @IBOutlet weak var buttonScissors: UIButton!
    
    @IBOutlet weak var stackViewChoice: UIStackView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var labelConnectivity: UILabel!
    
    var turnInfo = [PlayerTurnInfo]()
    var joinedPlayer = [MyPlayInfo.shared.name]
    
    let choices = ["Rock", "Paper", "Scissors"]
    var currentSec = 5
    var updatedName = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player vs Player"
        setupSocket()
        labelWinner.text = "WAITTING!"
        labelTimer.text = "--"
        stackViewChoice.isUserInteractionEnabled = false
        clearButtonChoice()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOCenter.shared.disconnect()
    }
    
    private func setupSocket() {
        SocketIOCenter.shared.setDelegate(self)
        SocketIOCenter.shared.connect()
    }
    
    func updateJoinedPlayer(_ player: String) {
        self.joinedPlayer.append(player)
        labelJoined.text = "Player: \(self.joinedPlayer.count)"
    }
    
    func updateChoice(_ players: [PlayerTurnInfo]) {
        if players.isEmpty && self.turnInfo.isEmpty { return }
        self.turnInfo.removeAll()
        self.turnInfo.append(contentsOf: players)
        displayTurnInfo()
    }
    
    @IBAction func actionRock(_ sender: Any) {
        move(.rock)
    }
    @IBAction func actionPaper(_ sender: Any) {
        move(.paper)
    }
    @IBAction func actionScissors(_ sender: Any) {
        move(.scissors)
    }
    
    func displayTurnInfo() {
        arena.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        turnInfo.forEach { (item) in
            let view: PlayerChoiceView =  Bundle.main.loadNibNamed("PlayerChoiceView", owner: nil, options: nil)?.first as! PlayerChoiceView
            view.updateData(item)
            arena.addArrangedSubview(view)
        }
    }
    
    func move(_ choice: Choice) {
        let selectedColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        buttonRock.backgroundColor = choice == .rock ? selectedColor : UIColor.white
        buttonPaper.backgroundColor = choice == .paper ? selectedColor : UIColor.white
        buttonScissors.backgroundColor = choice == .scissors ? selectedColor : UIColor.white
        SocketIOCenter.shared.sendMove(choice)
    }
    
    func clearButtonChoice() {
        buttonRock.backgroundColor = UIColor.white
        buttonPaper.backgroundColor = UIColor.white
        buttonScissors.backgroundColor = UIColor.white
    }
}

extension VsPlayerBattle: SocketIOCenterDelegate {
    func onConnectivityChanged(connected: Bool) {
        viewLoading.isHidden = connected
        labelConnectivity.text = connected ? "Connected" : "Disconnected. Reconnecting..."
        if !connected {
            labelWinner.text = "WAITTING!"
            labelTimer.text = "--"
            clearButtonChoice()
        }
    }
    
    func onEvent(name: EventName, data: [Any]?) {
        
        guard let data = data, !data.isEmpty else { return }
        guard let dict = data[0] as? [String: Any] else { return }
        //        guard let theJSONData = try?  JSONSerialization.data(
        //            withJSONObject: dict,
        //            options: .prettyPrinted
        //        ) else { return }
        
        switch name {
        case .yourInfo:
            MyPlayInfo.shared.updateName(dict["username"] as! String)
        case .joinGame:
            let number = dict["join_game"] as? Int ?? 0
            if number < 2 {
                labelWinner.text = "WAITTING!"
                labelTimer.text = "--"
                clearButtonChoice()
                updateChoice([])
            }
            labelJoined.text = "Player: \(dict["join_game"] as? Int ?? 0)"
        case .countDown:
            let timer = "\(dict["timer"] as? Int ?? 0)"
            guard let roundWait = dict["roundWait"] as? Bool, let roundStart = dict["roundStart"] as? Bool else { return }
            if roundStart { labelTimer.text = timer }
            labelTimer.isHidden = roundWait
            if roundWait {
                clearButtonChoice()
                labelWinner.text = "NEXT ROUND: \(timer)"
            }
            if roundStart {
                stackViewChoice.isUserInteractionEnabled = true
                labelWinner.text = "READY!"
                updateChoice([])
            }
        case .move:
            if let allow = dict["allow"] as? Bool {
                stackViewChoice.isUserInteractionEnabled = allow
            } else {
                stackViewChoice.isUserInteractionEnabled = false
            }
            if (dict["waitForPlayer"] as? Bool) != nil {
                clearButtonChoice()
                labelWinner.text = "WAITTING!"
                labelTimer.text = "--"
                updateChoice([])
            }
        case .result:
            guard let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dict["choices"],
                options: .prettyPrinted
            ) else { return }
            guard var turns = try? JSONDecoder()
                    .decode([PlayerTurnInfo].self, from: theJSONData) else {
                print("Can not decode data for: PlayerTurnInfo")
                return }
            var found = false
            for item in turns {
                if item.name == MyPlayInfo.shared.name {
                    found = true
                    break
                }
            }
            if !found {
                updateChoice([])
                Toast("You have to pick to see the result of this round!", .center).show(self.view)
            } else {
                updateChoice(turns)
            }
        case .userLeft:
            let number = dict["joinedPlayer"] as? Int ?? 0
            if number < 2 {
                clearButtonChoice()
                labelWinner.text = "WAITTING!"
                labelTimer.text = "--"
                updateChoice([])
            }
            labelJoined.text = "Player: \(dict["joinedPlayer"] as? Int ?? 0)"
        }
    }
}

