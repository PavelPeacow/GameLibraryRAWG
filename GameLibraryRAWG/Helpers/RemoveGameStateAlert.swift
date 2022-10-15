//
//  RemoveGameStateAlert.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 15.10.2022.
//

import Foundation
import UIKit

struct RemoveGameStateAlert {
    
    static func showGameStateAlert(on vc: UIViewController, with gameToDelete: Game, onCompletion: @escaping (Game) -> Void) {
        
        let ac = UIAlertController(title: "Add game state", message: nil, preferredStyle: .actionSheet)
        
        var game = gameToDelete
        
        var completedState = UIAlertAction(title: "Completed", style: .default) { _ in
            game.gameState = GameState.completed.rawValue
            onCompletion(game)
        }
        
        var playngState = UIAlertAction(title: "Playing", style: .default) { _ in
            game.gameState = GameState.playing.rawValue
            onCompletion(game)
        }
        
        var ownedState = UIAlertAction(title: "Owned", style: .default) { _ in
            game.gameState = GameState.owned.rawValue
            onCompletion(game)
        }
        
        var willPlayState = UIAlertAction(title: "Will play", style: .default) { _ in
            game.gameState = GameState.willPlay.rawValue
            onCompletion(game)
        }
                
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                
        switch game.gameState {
        case GameState.completed.rawValue:
            completedState = UIAlertAction(title: "Delete from Completed", style: .destructive, handler: { _ in
                game.gameState = nil
                onCompletion(game)
            })
        case GameState.playing.rawValue:
            playngState = UIAlertAction(title: "Delete from Playing", style: .destructive, handler: { _ in
                game.gameState = nil
                onCompletion(game)
            })
        case GameState.owned.rawValue:
            ownedState = UIAlertAction(title: "Delete from Owned", style: .destructive, handler: { _ in
                game.gameState = nil
                onCompletion(game)
            })
        case GameState.willPlay.rawValue:
            willPlayState = UIAlertAction(title: "Delete from Will Play", style: .destructive, handler: { _ in
                game.gameState = nil
                onCompletion(game)
            })
        default:
            print("game state error")
        }
        
        
        ac.addAction(completedState)
        ac.addAction(playngState)
        ac.addAction(ownedState)
        ac.addAction(willPlayState)
        ac.addAction(cancel)
        
        vc.present(ac, animated: true)
        
    }
        
}
