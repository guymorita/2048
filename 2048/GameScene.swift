//
//  GameView.swift
//  2048
//
//  Created by Guy Morita on 12/22/14.
//  Copyright (c) 2014 Rainbow Cats. All rights reserved.
//

import UIKit

let FirstXPosition = 1
let FirstYPosition = 1



class GameScene: UIView {
    
    var blockSize: CGFloat?
    
    var textureCache = Dictionary<String, UIImage>()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.blockSize = CGFloat(frame.width / 6)
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
    // [0, 1, 2, 3, 4, 5]
    // [0, 1, 2, 3, 4, 5]
    // [0, 1, 2, 3, 4, 5]
    // [0, 1, 2, 3, 4, 5]
    // [0, 1, 2, 3, 4, 5]
    // [0, 1, 2, 3, 4, 5]
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = CGFloat(FirstXPosition + column) * blockSize! + CGFloat(blockSize!/2)
        let y: CGFloat = CGFloat(FirstYPosition + row) * blockSize! + CGFloat(blockSize!/2)
        return CGPoint(x: x, y: y)
    }
    
    func addStartingBlockToBoard(block: Block, completion:() -> ()) {
        var texture = textureCache[block.spriteName]
        if texture == nil {
            texture = UIImage(named: block.spriteName)
            textureCache[block.spriteName] = texture
        }
        let sprite = UIImageView(image: texture)
        
        let spriteLabelFrame = CGRectMake(blockSize!*0.37, 0, blockSize!, blockSize!)
        let spriteLabel = UILabel(frame: spriteLabelFrame)
        spriteLabel.text = "\(block.value)"
        spriteLabel.font = UIFont(name: "Avenir-Black", size: 24.0)
        spriteLabel.textColor = UIColor.whiteColor()
        sprite.addSubview(spriteLabel)
        let blockPoint = pointForColumn(block.column, row: block.row)
        let spriteFrame = CGRectMake(0, 0, blockSize!, blockSize!)
        sprite.frame = spriteFrame
        sprite.center = blockPoint
        block.sprite = sprite
        self.addSubview(block.sprite!)
        
        completion()
    }
    
    func moveBlock(block: Block, completion:() -> ()) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            block.sprite!.center = self.pointForColumn(block.column, row: block.row)
        }) { (Bool) -> Void in
            //
        }
    }
    
}
