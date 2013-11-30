//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "Tetromino.h"
@interface Block (private)

- (void)initializeDefaults;
- (void)redrawPositionOnBoard;

@end


@implementation Block



+ (Block *)newEmptyBlockWithColorByType:(NSUInteger)blockType
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
			

- (void)initializeDefaults
{
	
	self.anchorPoint = ccp(0,0);
	self.position = ccp(0,0);
	self.opacity = 255;
	self.stuck = NO;
	self.disappearing = NO;
	_boardY = 0;
	_boardY = 0;
}

- (void)redrawPositionOnBoard
{
    //compute
	self.position = ccp(_boardX, _boardY);
}

//Remove these?
- (void)moveUp
{
	_boardY -= 1;
	[self redrawPositionOnBoard];
}

- (void)moveDown
{
	_boardY += 1;
	[self redrawPositionOnBoard];
}

-(void)MoveTo:(Block *)block
{
	_boardX = block.boardX;
	_boardY = block.boardY;
	
	[self redrawPositionOnBoard];
}

- (void)moveByX:(NSUInteger)offsetX
{
	_boardX += offsetX;
	[self redrawPositionOnBoard];
}

- (void)moveRight
{
	_boardX += 1;
	[self redrawPositionOnBoard];
}

- (void)moveLeft
{
	_boardX -= 1;
	[self redrawPositionOnBoard];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"self.boardX=%i", self.boardX];
    [description appendFormat:@", self.boardY=%i", self.boardY];

    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];

}


@end
