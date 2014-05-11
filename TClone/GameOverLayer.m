//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "GameOverLayer.h"
#import "GameLogicLayer.h"

@implementation GameOverLayer

+ (id)initLayer:(BOOL)won withPosition:(CGPoint) position {
    return [[self alloc] initWithWon:won withPosition:position];
}

- (id)initWithWon:(BOOL)isGameOver withPosition:(CGPoint)position {
    if ((self = [super init])) {
        
        NSString * message;
        if (isGameOver) {
            message = @"You Lose :[";
        } else {
            message = @"You Won!";
        }

//        CCLayerColor *ccLayerColor = [CCLayerColor layerWithColor:ccc4(255, 0, 255, 255)];
//        [self addChild:ccLayerColor z:0];
		
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(300,300,0);
        label.position = ccp(50, 50);

        //[self setAnchorPoint:position];
        [self setAnchorPoint:ccp(0, 0)];
        [self addChild:label];

        [self setZOrder:2];
        
//        [self runAction:
//         [CCSequence actions:
//          [CCDelayTime actionWithDuration:3],
//          [CCCallBlockN actionWithBlock:^(CCNode *node) {
//             [[CCDirector sharedDirector] replaceScene:[GameLogicLayer scene]];
//		 }],
//          nil]];
    }
    return self;
}

@end