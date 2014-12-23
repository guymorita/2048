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
    
    func gameBlockUpgraded(gameLogic: GameLogic)
    
    func gameBlockEntering(gameLogic: GameLogic)
}

class GameLogic {
    var blockArray: Array2D<Block>
    var score: Int
    var nextBlock: Block?
    var delegate: GameLogicDelegate?
    var movedBlock: Block?
    var upgradedBlock: Block?
    var assimilatedBlock: Block?
    var assimilatorBlock: Block?
    var movingFrom: (Int, Int) = (0, 0)
    
    init() {
        score = 0
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        delegate?.gameDidBegin(self)
    }
    
    func nextInitialBlock() -> Block {
        var foundOpenSlot = false
        var column = -1
        var row = -1
        while foundOpenSlot == false {
            column = Int(arc4random_uniform(4))
            row = Int(arc4random_uniform(4))
            if blockArray[column, row] == nil {
                foundOpenSlot = true
            }
        }
        let block = Block(column: column, row: row, value: 2)
        blockArray[column, row] = block
        return block
    }
    
    func tryMoveAllBlocksDown() {
        for (var row = blockArray.rows-1; row > 0; row--) {
            for col in 0...blockArray.columns-1 {
                let startingSlot = blockArray[col, row-1]
                if startingSlot == nil {
                    continue
                }
                tryMoveBlock(startingSlot!, endCol: startingSlot!.column, endRow: startingSlot!.row+1, completion: startingSlot!.lowerBlockByOneRow)
            }
        }
        let randCol = randColumn()
        if blockArray[randCol, 0] == nil {
            let newBlock = Block(column: randCol, row: 0)
            blockArray[randCol, 0] = newBlock
            nextBlock = newBlock
            movingFrom = (0, -1)
            delegate?.gameBlockEntering(self)
        }
    }
    
    func tryMoveAllBlocksRight() {
        for (var col = blockArray.columns-1; col > 0; col--) {
            for row in 0...blockArray.rows-1 {
                let startingSlot = blockArray[col-1, row]
                if startingSlot == nil {
                    continue
                }
                tryMoveBlock(startingSlot!, endCol: startingSlot!.column+1, endRow: startingSlot!.row, startingSlot!.shiftRightByOneColumn)
            }
        }
        let randRow = randRowww()
        if blockArray[0, randRow] == nil {
            let newBlock = Block(column: 0, row: randRow)
            blockArray[0, randRow] = newBlock
            nextBlock = newBlock
            movingFrom = (-1, 0)
            delegate?.gameBlockEntering(self)
        }
    }
    
    func tryMoveAllBlocksLeft() {
        for col in 0...blockArray.columns-2 {
            for row in 0...blockArray.rows-1 {
                let startingSlot = blockArray[col+1, row]
                if startingSlot == nil {
                    continue
                }
                tryMoveBlock(startingSlot!, endCol: startingSlot!.column-1, endRow: startingSlot!.row, completion: startingSlot!.shiftLeftByOneColumn)
            }
        }
        let randRow = randRowww()
        if blockArray[blockArray.columns-1, randRow] == nil {
            let newBlock = Block(column: blockArray.columns-1, row: randRow)
            blockArray[blockArray.columns-1, randRow] = newBlock
            nextBlock = newBlock
            movingFrom = (1, 0)
            delegate?.gameBlockEntering(self)
        }
    }
    
    func tryMoveBlock(startingBlock: Block, endCol: Int, endRow: Int, completion:()->()) {
        let blockAheadToCheck = blockArray[endCol, endRow]
        if blockAheadToCheck == nil {
            blockArray[endCol, endRow] = startingBlock
            blockArray[startingBlock.column, startingBlock.row] = nil
            completion()
            movedBlock = startingBlock
            delegate?.gameBlockDidMove(self)
        } else if (startingBlock.value == blockAheadToCheck?.value) {
            nextBlock = Block(column: blockAheadToCheck!.column, row: blockAheadToCheck!.row, value: blockAheadToCheck!.value*2)
            assimilatedBlock = startingBlock
            assimilatorBlock = blockAheadToCheck!
            blockArray[startingBlock.column, startingBlock.row] = nil
            blockArray[blockAheadToCheck!.column, blockAheadToCheck!.row] = nextBlock
            delegate?.gameBlockUpgraded(self)
        }
    }
    
    func randColumn() -> Int {
        return Int(arc4random_uniform(UInt32(blockArray.columns)))
    }
    
    func randRowww() -> Int {
        return Int(arc4random_uniform(UInt32(blockArray.rows)))
    }
}