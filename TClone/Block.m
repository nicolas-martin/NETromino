//
//  Tetromino.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tetromino.h"
@interface Block (private)

- (void)initializeDefaults;
- (void)redrawPositionOnBoard;

@end


@implementation Block
@synthesize boardX;
@synthesize boardY;
@synthesize stuck;
@synthesize disappearing;


+ (Block *)newEmptyBlockWithColorByType:(int)blockType
{
	NSString *filename = nil, *color = nil;
	Block *temp = nil;

	switch (blockType) {
		case I_block:
			color = @"cyan";
			break;
		case O_block:
			color = @"yellow";
			break;
		case J_block:
			color = @"green";
			break;
		case L_block:
			color = @"red";
			break;
		case Z_block:
			color = @"orange";
			break;
		case S_block:
			color = @"blue";
			break;
		case T_block:
			color = @"magenta";
			break;
		default:
			break;
	}
	
	if (color) {
		filename = [[NSString alloc] initWithFormat:@"%@.png", color];
		temp = [self spriteWithFile:filename];
		[temp initializeDefaults];
		
	}
	return temp;
	
}

- (NSComparisonResult)compareWithBlock:(Block *)block
{
	return [[NSNumber numberWithInt:self.boardX]
			compare:[NSNumber numberWithInt:block.boardX]];
}
			

//TODO Add client flexibility
- (void)initializeDefaults
{
	
	self.anchorPoint = ccp(0,0);
	self.position = ccp(0,0);
	self.opacity = 255;
	self.stuck = NO;
	self.disappearing = NO;
	self.boardX = 0;
	self.boardY = 0;
}

- (void)redrawPositionOnBoard 
{
	self.position = COMPUTE_X_Y(boardX, boardY);
}

- (void)moveUp
{
	boardY -= 1;
	[self redrawPositionOnBoard];
}

- (void)moveDown
{
	boardY += 1;
	[self redrawPositionOnBoard];
}

-(void)MoveTo:(Block *)block
{
	boardX = block.boardX;
	boardY = block.boardY;
	
	[self redrawPositionOnBoard];
}

- (void)moveByX:(int)offsetX
{
	boardX += offsetX;
	[self redrawPositionOnBoard];
}

- (void)moveRight
{
	boardX += 1;
	[self redrawPositionOnBoard];
}

- (void)moveLeft
{
	boardX -= 1;
	[self redrawPositionOnBoard];
}

@end
