//
//  Tetromino.h
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Block : CCSprite {
	int boardX, boardY;
	BOOL stuck;
	BOOL disappearing;
}
@property (readwrite, assign) int boardX;
@property (readwrite, assign) int boardY;
@property BOOL stuck;
@property BOOL disappearing;

+ (Block *)newEmptyBlockWithColorByType:(int)blockType;
- (void)moveUp;
- (void)moveDown;
- (void)moveLeft;
- (void)moveRight;
- (void)moveByX:(int)offsetX;
- (NSComparisonResult)compareWithBlock:(Block *)block;
-(void)MoveTo:(Block *)block;
+ (void)redrawBlock:(Block *)block;

@end
