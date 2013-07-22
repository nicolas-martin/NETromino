//
//  Tetromino.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Block.h"

@interface Block (private)

- (void)initializeDefaults;
- (void)redrawPositionOnBoard;

@end

@implementation Block

@synthesize boardX;
@synthesize boardY;
@synthesize stuck;
@synthesize disappearing;

+ (Block *)newBlock:(int)blockType
{
	NSString *filename = nil, *color = nil;
	Block *temp = nil;

	switch (blockType) {
		case kLetterI:
			color = @"cyan";
			break;
		case kLetterO:
			color = @"yellow";
			break;
		case kLetterS:
			color = @"green";
			break;
		case kLetterZ:
			color = @"red";
			break;
		case kLetterL:
			color = @"orange";
			break;
		case kLetterJ:
			color = @"blue";
			break;
		case kLetterT:
			color = @"magenta";
			break;
		default:
			break;
	}
	
	if (color) {
		filename = [[NSString alloc] initWithFormat:@"%@.png", color];
		temp = [[self spriteWithFile:filename] retain];
		[filename release];
		
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
// !!!: Actually?
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
	//[self runAction:[MoveTo actionWithDuration:1.0/45.0 position:COMPUTE_X_Y(boardX, boardY)]];
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

- (void)moveLeft
{
	boardX -= 1;
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



@end
