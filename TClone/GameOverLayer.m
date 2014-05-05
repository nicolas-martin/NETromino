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

- (id)initWithWon:(BOOL)won withPosition:(CGPoint)position {
    if ((self = [super init])) {
        
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Lose :[";
        }
		
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(300,300,0);
        label.position = position;
        [self addChild:label];
        
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