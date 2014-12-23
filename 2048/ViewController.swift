//
//  ViewController.swift
//  2048
//
//  Created by Guy Morita on 12/22/14.
//  Copyright (c) 2014 Rainbow Cats. All rights reserved.
//

import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let screenWidth = screenBounds.width
let screenHeight = screenBounds.height

class ViewController: UIViewController, GameLogicDelegate {
    
    var gameLogic: GameLogic!
    var scene: GameScene!
    var freeToMove: Bool!

    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let sceneFrame = CGRectMake(0, 100, screenWidth, screenWidth)
//        scene = GameScene(frame: sceneFrame)
//        self.view.addSubview(scene)
        
        resetScene()
        
        // Setup Delegate
        gameLogic = GameLogic()
        gameLogic.delegate = self
        gameLogic.beginGame()
        freeToMove = true
        
        playAgainButton.layer.cornerRadius = 5.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didSwipeDown(sender: UISwipeGestureRecognizer) {
        if freeToMove == true {
            gameLogic.tryMoveAllBlocksDown()
        }
    }
    
    @IBAction func didSwipeRight(sender: UISwipeGestureRecognizer) {
        if (freeToMove == true) {
             gameLogic.tryMoveAllBlocksRight()
        }
    }
    @IBAction func didSwipeLeft(sender: UISwipeGestureRecognizer) {
        if (freeToMove == true) {
            gameLogic.tryMoveAllBlocksLeft()
        }
    }
    @IBAction func didSwipeUp(sender: UISwipeGestureRecognizer) {
        if (freeToMove == true) {
            gameLogic.tryMoveAllBlocksUp()
        }
    }
    @IBAction func didTapPlayAgain(sender: UIButton) {
        resetScene()
        gameLogic.resetGame()
    }
    
    func resetScene() {
        let sceneFrame = CGRectMake(0, 100, screenWidth, screenWidth)
        if scene != nil {
            scene.removeFromSuperview()
        }

        scene = GameScene(frame: sceneFrame)
        self.view.addSubview(scene)
    }
    
    func gameDidBegin(gameLogic: GameLogic) {
        scene.addStartingBlockToBoard(gameLogic.nextInitialBlock()) {
            self.scene.addStartingBlockToBoard(self.gameLogic.nextInitialBlock()) {
                self.scene.addStartingBlockToBoard(self.gameLogic.nextInitialBlock()) {
                    self.updateScoreLabel()
                }
            }
        }
    }
    
    func gameBlockDidMove(gameLogic: GameLogic) {
        scene.moveBlock(gameLogic.movedBlock!) {
            
        }
    }
    
    func gameBlockUpgraded(gameLogic: GameLogic) {
        scene.upgradeBlock(gameLogic.nextBlock!, assimilatorBlock: gameLogic.assimilatorBlock!, assimilatedBlock: gameLogic.assimilatedBlock!) {
            //
        }
    }
    
    func gameBlockEntering(gameLogic: GameLogic) {
        scene.insertNewBlock(gameLogic.nextBlock!, movingFrom: gameLogic.movingFrom){
            
        }
        self.updateScoreLabel()
    }
    
    func gameFreeToMove(gameLogic: GameLogic) {
        freeToMove = true
    }
    
    func gameNotFreeToMove(gameLogic: GameLogic) {
        freeToMove = false
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(gameLogic.score)"
    }


}

