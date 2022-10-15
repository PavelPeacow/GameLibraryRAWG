//
//  AddGameStateAlert.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 15.10.2022.
//

import Foundation
import UIKit

struct AddGameStateAlert {
    
    static func showGameStateAlert(on vc: UIViewController, with gameToAdd: Game, onCompletion: @escaping (Game) -> Void) {
        
        let ac = UIAlertController(title: "Add game state", message: nil, preferredStyle: .actionSheet)
        
        var game = gameToAdd
        
        let completedState = UIAlertAction(title: "Completed", style: .default) { _ in
            game.gameState = GameState.completed.rawValue
            onCompletion(game)
        }
        
        let playngState = UIAlertAction(title: "Playing", style: .default) { _ in
            game.gameState = GameState.playing.rawValue
            onCompletion(game)
        }
        
        let ownedState = UIAlertAction(title: "Owned", style: .default) { _ in
            game.gameState = GameState.owned.rawValue
            onCompletion(game)
        }
        
        let willPlayState = UIAlertAction(title: "Will play", style: .default) { _ in
            game.gameState = GameState.willPlay.rawValue
            onCompletion(game)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                
        ac.addAction(completedState)
        ac.addAction(playngState)
        ac.addAction(ownedState)
        ac.addAction(willPlayState)
        ac.addAction(cancel)
        
        vc.present(ac, animated: true)
        
    }
        
}
