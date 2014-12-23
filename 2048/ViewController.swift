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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sceneFrame = CGRectMake(0, 100, screenWidth, screenWidth)
        scene = GameScene(frame: sceneFrame)
        self.view.addSubview(scene)
        
        // Setup Delegate
        gameLogic = GameLogic()
        gameLogic.delegate = self
        gameLogic.beginGame()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didSwipeDown(sender: UISwipeGestureRecognizer) {
        gameLogic.tryMoveAllBlocksDown()
    }
    
    @IBAction func didSwipeRight(sender: UISwipeGestureRecognizer) {
        gameLogic.tryMoveAllBlocksRight()
    }
    @IBAction func didSwipeLeft(sender: UISwipeGestureRecognizer) {
        gameLogic.tryMoveAllBlocksLeft()
    }
    @IBAction func didSwipeUp(sender: UISwipeGestureRecognizer) {
    }
    func gameDidBegin(gameLogic: GameLogic) {
        scene.addStartingBlockToBoard(gameLogic.nextInitialBlock()) {
            self.scene.addStartingBlockToBoard(self.gameLogic.nextInitialBlock()) {
                self.scene.addStartingBlockToBoard(self.gameLogic.nextInitialBlock()) {
                    //
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
            //
        }
    }


}

