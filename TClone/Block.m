//
//  Tetromino.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Block.h"
typedef uint8_t BLOCK[4][4];
@interface Block (private)

- (void)initializeDefaults;
- (void)redrawPositionOnBoard;

@end

static BLOCK bI[2] = {
	{
		{0,0,0,0},
		{1,1,1,1},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,1,0,0},
		{0,1,0,0},
		{0,1,0,0},
		{0,1,0,0}
	}
};
static BLOCK bO[1] = {
	{
		{0,2,2,0},
		{0,2,2,0},
		{0,0,0,0},
		{0,0,0,0}
	}
};
static BLOCK bJ[4] = {
	{
		{3,0,0,0},
		{3,3,3,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,3,3,0},
		{0,3,0,0},
		{0,3,0,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{3,3,3,0},
		{0,0,3,0},
		{0,0,0,0}
	}, {
		{0,3,0,0},
		{0,3,0,0},
		{3,3,0,0},
		{0,0,0,0}
	},
};
static BLOCK bL[4] = {
	{
		{0,0,4,0},
		{4,4,4,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,4,0,0},
		{0,4,0,0},
		{0,4,4,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{4,4,4,0},
		{4,0,0,0},
		{0,0,0,0}
	}, {
		{4,4,0,0},
		{0,4,0,0},
		{0,4,0,0},
		{0,0,0,0}
	}
};
static BLOCK bZ[2] = {
	{
		{5,5,0,0},
		{0,5,5,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,0,5,0},
		{0,5,5,0},
		{0,5,0,0},
		{0,0,0,0}
	}
};
static BLOCK bS[2] = {
	{
		{0,1,1,0},
		{1,1,0,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{1,0,0,0},
		{1,1,0,0},
		{0,1,0,0},
		{0,0,0,0}
	}
};
static BLOCK bT[4] = {
	{
		{0,2,0,0},
		{2,2,2,0},
		{0,0,0,0},
		{0,0,0,0}
	}, {
		{0,2,0,0},
		{0,2,2,0},
		{0,2,0,0},
		{0,0,0,0}
	}, {
		{0,0,0,0},
		{2,2,2,0},
		{0,2,0,0},
		{0,0,0,0}
	}, {
		{0,2,0,0},
		{2,2,0,0},
		{0,2,0,0},
		{0,0,0,0}
	}
};

static BLOCK *blocks[7] = {bI, bO, bJ, bL, bZ, bS, bT};
static NSInteger orientationCount[7] = {2, 1, 4, 4, 2, 2, 4};

@implementation Block
@synthesize boardX;
@synthesize boardY;
@synthesize stuck;
@synthesize disappearing;
@synthesize orientation;
@synthesize type;

+ (Block *)newBlock:(int)blockType
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
		temp = [[self spriteWithFile:filename] retain];
		[filename release];
		
		[temp initializeDefaults];
		
	}
	return temp;
	
}

+ (id)blockWithType:(tetrominoType)blockType
		orientation:(NSInteger)blockOrientation
{
	return [[[self alloc] initWithType:blockType
						   orientation:blockOrientation] autorelease];
}

- (id)initWithType:(tetrominoType)blockType
	   orientation:(NSInteger)blockOrientation
{
	type = blockType;
	orientation = (blockOrientation % orientationCount[type]);
	
	return self;
}

+ (id)randomBlockUsingBlockFrequency:(NSNumber*)blockFrequency
{
	return [[[self alloc] initWithRandomTypeAndOrientationUsingFrequency:blockFrequency] autorelease];
}

- (id)initWithRandomTypeAndOrientationUsingFrequency:(NSNumber*)blockFrequency
{
	blockFrequency = random() % 7;
	
	type = (tetrominoType)blockFrequency;
	orientation = (random() % orientationCount[type]);
	
	return self;
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

- (void)rotateInDirection:(RotationDirection)direction
{/*
	NSInteger newOrientation = (orientation + direction + [self numOrientations]) % [self numOrientations];
	return [iTetBlock blockWithType:type
						orientation:newOrientation
						   position:position];*/
}



@end
