//
//  GameScene.m
//  Tetris
//
//  Created by Joshua Aburto on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IntroLayer.h"
#import "GameLogicLayer.h"


@implementation IntroLayer

// Helper class method that creates a Scene with the IntroLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    IntroLayer *introLayer = [IntroLayer node];
    
    // add layer as a child to scene
    [scene addChild: introLayer];
    
    // return the scene
    return scene;
}


-(id) init
{
	if ((self = [super init])) {
	
		NSString * message;
            message = @"Hello World!";
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node)
		{
             [[CCDirector sharedDirector] replaceScene:[GameLogicLayer scene]];
		 }],
          nil]];


	}
	return self;
	
}

-(void) onEnter
{
	
    [super onEnter];
	//CCLayer *layer = [GameLogicLayer node];
	//[self addChild:layer z:1];
	

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLogicLayer scene] ]];
}
@end

