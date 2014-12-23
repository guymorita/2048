//
//  Block.swift
//  2048
//
//  Created by Guy Morita on 12/22/14.
//  Copyright (c) 2014 Rainbow Cats. All rights reserved.
//

import Foundation
import UIKit

let NumberOfColors: UInt32 = 4

func getColorIdx(value: Int) -> Int {
    switch value {
    case 2:
        return 0
    case 4:
        return 1
    case 8:
        return 2
    case 16:
        return 3
    case 32:
        return 0
    case 64:
        return 1
    case 128:
        return 2
    case 256:
        return 3
    case 512:
        return 0
    case 1028:
        return 1
    case 2048:
        return 2
    default:
        return 0
    }
}

func randStartingValue() -> Int {
    return [2, 4][Int(arc4random_uniform(2))]
}

enum BlockColor: Int, Printable {
    
    case Blue = 0, Purple = 1, Red = 2, Teal = 3
    
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue" // 2, 32, 512
        case .Purple:
            return "purple" // 4, 64, 1024
        case .Red:
            return "red" // 8, 128, 2048
        case .Teal:
            return "teal" // 16, 256
        }
    }
    
    var description: String {
        return self.spriteName
    }
    
    static func getColor(val: Int) -> BlockColor {
        return BlockColor(rawValue: val)!
    }
}

class Block: Hashable, Printable {
    
    var color: BlockColor
    
    var column: Int
    var row: Int
    
    var value: Int
    
    var sprite: UIView?
    
    var spriteName: String {
        return color.description
    }
    
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column: Int, row: Int, color: BlockColor, value: Int) {
        self.column = column
        self.row = row
        self.value = value
        self.color = color
    }
    
    convenience init(column: Int, row: Int, value: Int) {
        var colorVal: Int = getColorIdx(value)
        self.init(column: column, row: row, color: BlockColor.getColor(colorVal), value: value)
    }
    
    convenience init(column: Int, row: Int) {
        var value = randStartingValue()
        var colorVal: Int = getColorIdx(value)
        self.init(column: column, row: row, color: BlockColor.getColor(colorVal), value: value)
    }
    
    final func lowerBlockByOneRow() {
        shiftBy(0, rows: 1)
    }
    
    final func raiseBlockByOneRow() {
        shiftBy(0, rows: -1)
    }
    
    final func shiftRightByOneColumn() {
        shiftBy(1, rows: 0)
    }
    
    final func shiftLeftByOneColumn() {
        shiftBy(-1, rows: 0)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
    }
    
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
}

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}