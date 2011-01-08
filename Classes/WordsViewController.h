//
//  WordsViewController.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import "JSON/JSON.h"

@interface WordsViewController : UIViewController {
	NSMutableData *resp;
	
	IBOutlet UITextField *word;
	IBOutlet UILabel *definition;
	IBOutlet UILabel *scoreLabel;
	IBOutlet UILabel *timerLabel;
	NSMutableArray *newWords;
	Word *curWord;
	NSMutableArray *pastWords;
	NSTimer *timer;
	int time;
	int points;
}

- (void)getNewWords;
- (void)setDefinitionLabelText:(NSString*) defText;
- (IBAction)testWord;
- (IBAction)skipWord;
- (void)gotWordCorrect;
- (void)setNewWord;
- (void)addPoints:(int)numPoints;
- (void)addTime:(int)numSecs;
- (void)tick;
- (void)resetTimer;
- (void)stopTimer;
- (void)startTimer;


@end

