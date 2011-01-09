//
//  GameViewController.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
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
	
	Game* game;
}

- (IBAction)testWord;
- (IBAction)skipWord;

- (void)setDefinitionLabelText:(NSString*) defText;

- (void)updateWord;
- (void)updateScore;
- (void)updateTime;

@end

