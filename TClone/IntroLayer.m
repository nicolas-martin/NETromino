//
// Created by Nicolas Martin on 13-08-15.
//
//

#import "IntroLayer.h"
#import "GameLogicLayer.h"
#import "TClone-Swift.h"

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
        
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = [CCColor blueColor];
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        [[CCDirector sharedDirector] replaceScene:[GameLogicLayer scene]];



	}
	return self;
	
}

-(void) onEnter
{
	
    [super onEnter];
	//CCLayer *layer = [GameLogicLayer node];
	//[self addChild:layer z:1];
	

    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLogicLayer scene] ]];
    [[CCDirector sharedDirector] replaceScene:[GameMenu scene]];
    
    
}
@end

