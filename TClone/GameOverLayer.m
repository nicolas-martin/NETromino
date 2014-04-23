//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "GameOverLayer.h"
#import "GameLogicLayer.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won];    
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super init])) {
        
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Lose :[";
        }
		
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(300,300,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[GameLogicLayer scene]];
		 }],
          nil]];
    }
    return self;
}

@end