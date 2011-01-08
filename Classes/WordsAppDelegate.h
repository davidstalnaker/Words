//
//  WordsAppDelegate.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordsViewController;

@interface WordsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WordsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WordsViewController *viewController;

@end

