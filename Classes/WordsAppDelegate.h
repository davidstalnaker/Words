//
//  WordsAppDelegate.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#define UIAppDelegate \
((WordsAppDelegate *)[UIApplication sharedApplication].delegate)

@class GameViewController;

@interface WordsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
    GameViewController *viewController;
	MainViewController *mainWindowController;
}

- (void)startGame;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet GameViewController *viewController;
@property (nonatomic, retain) IBOutlet MainViewController *mainWindowController;

@end

