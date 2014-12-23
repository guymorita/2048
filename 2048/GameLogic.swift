//
//  GameLogic.swift
//  2048
//
//  Created by Guy Morita on 12/22/14.
//  Copyright (c) 2014 Rainbow Cats. All rights reserved.
//

import Foundation

let NumColumns = 4
let NumRows = 4

protocol GameLogicDelegate {
    func gameDidBegin(gameLogic: GameLogic)
    
    func gameBlockDidMove(gameLogic: GameLogic)
    
//    func gameBlockUpgraded(gameLogic: GameLogic)
}

class GameLogic {
    var blockArray: Array2D<Block>
    var score: Int
    var nextBlock: Block?
    var delegate: GameLogicDelegate?
    var recentlyMovedBlock: Block?
    
    init() {
        score = 0
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        delegate?.gameDidBegin(self)
    }
    
    func nextInitialBlock() -> Block {
        let column = Int(arc4random_uniform(4))
        let row = Int(arc4random_uniform(4))
        let block = Block(column: column, row: row, value: 2)
        blockArray[column, row] = block
        return block
    }
    
    func tryMoveAllBlocksDown() {
        // iterate through all blocks starting from top
        // attempt to move down unless there is something below it
            // if there is nothing, move it
            // if it's the same number, combine
            // if it's a different number, don't do anything
        // if it moves, then inform the view controller

        for (var row = blockArray.rows-1; row > 0; row--) {
            for col in 0...blockArray.columns-1 {
                let startingSlot = blockArray[col, row-1]
                if startingSlot == nil {
                    continue
                }
                tryMoveBlockDown(startingSlot!, endCol: startingSlot!.column, endRow: startingSlot!.row+1)
            }
        }
    }
    
    func tryMoveBlockDown(startingBlock: Block, endCol: Int, endRow: Int) {
        let blockAheadToCheck = blockArray[endCol, endRow]
        if blockAheadToCheck == nil {
            blockArray[endCol, endRow] = startingBlock
            blockArray[startingBlock.column, startingBlock.row] = nil
            startingBlock.lowerBlockByOneRow()
            recentlyMovedBlock = startingBlock
            delegate?.gameBlockDidMove(self)
        } else if (startingBlock.value == blockAheadToCheck?.value) {
            let newBlock = Block(column: blockAheadToCheck!.column, row: blockAheadToCheck!.row, value: blockAheadToCheck!.value*2)
            blockArray[startingBlock.column, startingBlock.row] = nil
            blockArray[blockAheadToCheck!.column, blockAheadToCheck!.row] = newBlock
            
        }
    }
    
    func combineBlocks(
}