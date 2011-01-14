//
//  GameViewController.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import "JSON/JSON.h"
#import "Game.h"

@interface GameViewController : UIViewController <GameObserver> {
	
	IBOutlet UITextField *word;
	IBOutlet UILabel *definition;
	IBOutlet UILabel *scoreLabel;
	IBOutlet UILabel *timerLabel;
	IBOutlet UIActivityIndicatorView *spinner;
	
	Game* game;
}

- (IBAction)testWord;
- (IBAction)skipWord;


- (void)setDefinitionLabelText:(NSString*) defText;

- (void)updateWord;
- (void)updateScore;
- (void)updateTime;
- (void)startWaiting;
- (void)stopWaiting;

@property (readwrite, retain) Game *game;

@end

