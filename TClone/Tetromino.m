//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"
#import "Block.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface Tetromino (private)
- (void)initializeTetromino;
@end

@implementation Tetromino



typedef uint8_t BLOCK[4][4];
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
//This is a 2D array
static BLOCK *blocks[7] = {bI, bO, bJ, bL, bZ, bS, bT};
static NSUInteger orientationCount[7] = {2, 1, 4, 4, 2, 2, 4};




- (BLOCK*)contents
{
	return &(blocks[self.type][_orientation]);
}

- (BLOCK*)contents:(tetrominoType)currentType and:(NSUInteger)currentOrientation
{
    return &(blocks[currentType][currentOrientation]);
}


+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSUInteger)positionX BoardY:(NSUInteger)positionY CurrentOrientation:(NSUInteger)CurrentOrientation;
{
	return [[self alloc] initWithTypeRotationPosition:blockType rotationDirection:blockOrientation BoardX:positionX BoardY:positionY CurrentOrientation:CurrentOrientation];
}

- (id)initWithTypeRotationPosition:(tetrominoType)blockType rotationDirection:(RotationDirection)blockDirection BoardX:(NSUInteger)positionX BoardY:(NSUInteger)positionY CurrentOrientation:(NSUInteger)CurrentOrientation;
{
	if ((self = [super init]))
	{
		self.anchorX = positionX;
		self.anchorY = positionY;
		self.type = blockType;
		_orientation = CurrentOrientation;

		_orientation = (_orientation + blockDirection + [self numOrientations]) % [self numOrientations];

		_blocksInTetromino = [[NSMutableArray alloc] init];
		
		BLOCK* contents = [self contents];

		for (NSUInteger row = 0; row < 4; row++)
		{
			for (NSUInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];

				// If the cell is empty, skip to the next iteration of the Ïloop
				if (cellType == 0)
					continue;
				
				Block *newBlock = [Block blockWithBlockType:self.type];
				newBlock.boardX = (row + _anchorX);
				newBlock.boardY = col + _anchorY;
                //copmute?
				newBlock.position = ccp(newBlock.boardX, newBlock.boardY);
                [self setAnchorPoint:ccp(0, 0)];
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
		
		[self initializeTetromino];
		
	}
	return self;

}

- (NSUInteger)numOrientations
{
	return orientationCount[self.type];
}


+ (id)randomBlockUsingBlockFrequency {
	return [[self alloc] initWithRandomTypeAndOrientationUsingFrequency];
}

//This works with random orientation and random types!!
- (id)initWithRandomTypeAndOrientationUsingFrequency {

	if ((self = [super init]))
	{

        NSUInteger blockFrequency = arc4random() % 7;
		self.type = (tetrominoType)blockFrequency;
        NSUInteger randomOrientation = arc4random() % orientationCount[self.type];

		_orientation = randomOrientation;
		_blocksInTetromino = [[NSMutableArray alloc] init];
				
		BLOCK* contents = [self contents];
		
		self.anchorX = rowoffset;
		self.anchorY = 0;
		
		for (NSUInteger row = 0; row < 4; row++)
		{
			for (NSUInteger col = 0; col < 4; col++)
			{
				// Get the contents of this cell of the block
				uint8_t cellType = (*contents)[(4 - 1) - row][col];
				
				// If the cell is empty, skip to the next iteration of the loop
				if (cellType == 0)	
					continue;
			

				Block *newBlock = [Block blockWithBlockType:self.type];
				newBlock.boardX = row + _anchorX;
				newBlock.boardY = col + _anchorY;
                //[newBlock setAnchorPoint:ccp(0,0)];


				newBlock.position = ccp(newBlock.boardX, newBlock.boardY );
                [self setAnchorPoint:ccp(0, 0)];
				[self addChild:newBlock];
				[_blocksInTetromino addObject:newBlock];
				
			}
		}
				
		[self initializeTetromino];
		
	}
	return self;
}

- (id)initWithType:(tetrominoType)blockType
	   orientation:(NSUInteger)blockOrientation
{
	self.type = blockType;
	_orientation = (blockOrientation % orientationCount[self.type]);
	
	return self;
}

- (void)initializeTetromino
{
	self.stuck = NO;
	//[self setShape];
	/*Block *firstBlock = [children_ objectAtIndex:0];
	self.anchorX = firstBlock.boardX;
	self.anchorY = firstBlock.boardY;*/
    [self setAnchorPoint:ccp(0, 0)];
}

- (BOOL)stuck
{
	for (Block *block in self.children) {
		stuck = block.stuck;
	}
	return stuck;
}

- (void)setStuck:(BOOL)stuckValue
{
	stuck = stuckValue;
	for (Block *block in self.children) {
		block.stuck = stuckValue;
	}
}

- (BOOL)isBlockInTetromino:(id)block
{
    if (block != nil)
    {
        for (Block *currentBlock in self.children) {
            if ([currentBlock isEqual:block]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)moveTetrominoInDirection:(Tetromino *)tetromino inDirection:(MoveDirection)direction
{
    for (Block* currentBlock in tetromino.children)
    {
        [currentBlock moveByX:direction];
    }

    tetromino.anchorX += direction;
}

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction {

    return [Tetromino blockWithType:userTetromino.type Direction:direction BoardX:userTetromino.anchorX BoardY:userTetromino.anchorY CurrentOrientation:userTetromino.orientation];
}

- (void)moveTetrominoDown {

	NSArray *reversedChildren = [[NSArray alloc] initWithArray:self.children];  // make copy

	for (Block *currentBlock in [reversedChildren reverseObjectEnumerator])
	{
		//move each block down
		[currentBlock moveDown];
	}

	self.anchorY += 1;
}

- (CGPoint)leftMostPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.x > currentBlock.boardX) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
    [self setLeftMostPosition:myLeftPosition];
	return myLeftPosition;
	
}

- (CGPoint)rightMostPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.x < currentBlock.boardX) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
    [self setRightMostPosition:myRightPosition];
	return myRightPosition;
}

- (CGPoint)highestPosition
{
	
	CGPoint	myLeftPosition = ccp(999,999);
	for (Block *currentBlock in self.children) {
		if ( myLeftPosition.y > currentBlock.boardY) {
			myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);

		}
	}
    [self setHighestPosition:myLeftPosition];
	return myLeftPosition;
	
}

- (CGPoint)lowestPosition
{
	CGPoint myRightPosition = ccp(-1, -1);
	for (Block *currentBlock in self.children) {
		if (myRightPosition.y < currentBlock.boardY) {
			myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
		}
	}
    [self setLowestPosition:myRightPosition];
	return myRightPosition;
}

-(void)MoveBoardPosition:(Tetromino *)ToTetromino
{
    NSUInteger i = 0;
    for (Block *block in self.children)
    {
        Block *child = [ToTetromino.children objectAtIndex:i];
        NSUInteger newBoardX = child.boardX;
        NSUInteger newBoardY = child.boardY;
        [block setBoardX: newBoardX];
        [block setBoardY: newBoardY];

        i++;
    }
}


- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"self.type=%d", self.type];
    [description appendFormat:@", self.orientation=%i", self.orientation];
    [description appendFormat:@", self.lowestPosition.x=%f", self.lowestPosition.x];
    [description appendFormat:@", self.lowestPosition.y=%f", self.lowestPosition.y];
    [description appendFormat:@", self.anchorX=%i", self.anchorX];
    [description appendFormat:@", self.anchorY=%i", self.anchorY];

    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];

}
@end
