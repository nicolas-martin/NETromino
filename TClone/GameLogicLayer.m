//
//  GameLogicLayer.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLogicLayer.h"
#import "GameOverLayer.h"
#import "CCNode+SFGestureRecognizers.h"
#import "Field.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface GameLogicLayer (private)

- (void)startGame;
- (void)processTaps;

@end

@implementation GameLogicLayer


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];

    Field *main = [Field node];
    [scene addChild:main z:1];

    Field *field1 = [Field node];
    [scene addChild:field1 z:1];

    Field *field2 = [Field node];
    [scene addChild:field2 z:1];

    Field *field3 = [Field node];
    [scene addChild:field3 z:1];

    Field *field4 = [Field node];
    [scene addChild:field4 z:1];


    GameLogicLayer *layer = [[GameLogicLayer alloc] initWithFields:main and:field1 and:field2 and:field3 and:field4];
    [scene addChild: layer];
    
    return scene;
}

- (id)initWithFields:(Field *)mainFieldLayer and:(Field *)otherFieldLayer1 and:(Field *)otherFieldLayer2 and:(Field *)otherFieldLayer3 and:(Field *)otherFieldLayer4 {

	if ((self = [super init]))
	{

        _MainField = mainFieldLayer;
        _FieldLayer1 = otherFieldLayer1;
        _FieldLayer2 = otherFieldLayer2;
        _FieldLayer3 = otherFieldLayer3;
        _FieldLayer4 = otherFieldLayer4;

        [_MainField initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"32.tmx"]];
        [_FieldLayer1 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer2 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer3 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];
        [_FieldLayer4 initWithTileMap:[CCTMXTiledMap tiledMapWithTMXFile:@"16.tmx"]];



        CGSize winSize = [CCDirector sharedDirector].winSize;

        [_MainField setPosition:ccp(0,0)];
        [_FieldLayer1 setPosition:ccp(winSize.width - _FieldLayer1.tileMap.contentSize.width, 0)];
        [_FieldLayer2 setPosition:ccp(winSize.width - _FieldLayer2.tileMap.contentSize.width,
        winSize.height - _FieldLayer2.tileMap.contentSize.height)];
        [_FieldLayer3 setPosition:ccp(winSize.width - (_FieldLayer3.tileMap.contentSize.width + 200), 0)];
        [_FieldLayer4 setPosition:ccp(winSize.width - (_FieldLayer4.tileMap.contentSize.width + 200),
        winSize.height - (_FieldLayer4.tileMap.contentSize.height))];

        self.isTouchEnabled = YES;

		//creates gesture recognizer for the layer
		UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGestureRecognizer:)];
		swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		swipeRightGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeRightGestureRecognizer];
		
		UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGestureRecognizer:)];
		swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		swipeLeftGestureRecognizer.delegate = self;
		[self addGestureRecognizer:swipeLeftGestureRecognizer];


        [gameController initWithField:_MainField];

		[self startGame];
	
	}
	return self;
}
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = (int) (position.x / _MainField.tileMap.tileSize.width);
    int y = (int) (((_MainField.tileMap.mapSize.height * _MainField.tileMap.tileSize.height) - position.y) / _MainField.tileMap.tileSize.height);
    return ccp(x, y);
}
- (void)swipeRightGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[gameController rotateTetromino:rotateClockwise];
	
}

- (void)swipeLeftGestureRecognizer:(UISwipeGestureRecognizer*)aGestureRecognizer
{
	[gameController rotateTetromino:rotateCounterclockwise];
	
}

- (void)startGame
{
	[gameController tryToCreateNewTetromino];

	frameCount = 0;
	moveCycleRatio = 40;
	[self schedule:@selector(updateBoard:) interval:(1.0/60.0)];
}

- (void)updateBoard:(ccTime)dt
{
	frameCount += 1;
	if (frameCount % moveCycleRatio == 0)
	{
        [gameController moveDownOrCreate];

	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];


    [gameController viewTap:location];

}


@end
