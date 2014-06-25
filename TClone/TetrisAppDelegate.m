//
//  AppDelegate.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 11/13/12.
//  Copyright Razeware LLC 2012. All rights reserved.
//

#import "TetrisAppDelegate.h"
#import "IntroLayer.h"
#import "CCBReader.h"

@implementation MyNavigationController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString *configPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Published-iOS"];     // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];

    NSMutableDictionary *cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];

    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
  if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
    [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
  else
    [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif

    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];

    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];

    [self setupCocos2dWithOptions:cocos2dSetup];

    return YES;
}

- (CCScene *)startScene {
    return [IntroLayer scene];
}

@end
