//
//  BattleScene.swift
//  WhatIsCode
//
//  Created by Trần Mạnh Quý on 11/27/20.
//

import UIKit

class VsBotBattle: UIViewController {
    
    @IBOutlet weak var arena: UIStackView!
    @IBOutlet weak var labelWinner: UILabel!
    var turnInfo = [PlayerTurnInfo]()
    var bot = Bot()
    let choices = ["Rock", "Paper", "Scissors"]
    
    @IBOutlet weak var buttonSmash: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player vs Bot"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionRock(_ sender: Any) {
        move(.rock)
    }
    @IBAction func actionPaper(_ sender: Any) {
        move(.paper)
    }
    @IBAction func actionSci(_ sender: Any) {
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
    
    func findWinner() -> String {
        var player1 = turnInfo[0]
        var player2 = turnInfo[1]
        
        player1.state = "Lose"
        player2.state = "Lose"
        
        if player1.choice == player2.choice {
            player1.state = "Draw"
            player2.state = "Draw"
            return "Draw"
        } else if player1.displayChoice == Choice.paper {
            if player2.displayChoice == Choice.scissors {
                player2.state = "Win"
                return player2.name
            }
            player1.state = "Win"
            return player1.name
        } else if player1.displayChoice == Choice.scissors {
            if player2.displayChoice == Choice.rock {
                player2.state = "Win"
                return player2.name
            }
            player1.state = "Win"
            return player1.name
        } else {
            if player2.displayChoice == Choice.paper {
                player2.state = "Win"
                return player2.name
            }
            player1.state = "Win"
            return player1.name
        }
    }
    
    func move(_ choice: Choice) {
        turnInfo.removeAll()
        let myTurn = PlayerTurnInfo(choice: choice.rawValue, name: MyPlayInfo.shared.name)
        let botTurn = bot.move(choices)
        turnInfo.append(contentsOf: [myTurn, botTurn])
        
        let result = findWinner()
        if result == "Draw" {
            labelWinner.text = "Draw game!!!"
        } else {
            labelWinner.text = "Winner: \(findWinner())"
        }
        displayTurnInfo()
    }
}

class Bot {
    func move(_ choices: [String]) -> PlayerTurnInfo {
        let index = Int.random(in: 0..<3)
        let choice: Choice = Choice(rawValue: choices[index]) ?? Choice.paper
        let turn = PlayerTurnInfo(choice: choice.rawValue, name: "Bot")
        return turn
    }
}
