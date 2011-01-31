//
//  GameViewController.m
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

@synthesize game;

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (IBAction)testWord{
	[game testWord:[word text]];
}

- (IBAction)skipWord {
	[game skipWord];
}



- (void)setDefinitionLabelText:(NSString*) defText {
	CGRect origFrame = definition.frame;
	CGSize maximumSize = CGSizeMake(origFrame.size.width, 9999);
    CGSize defStringSize = [defText sizeWithFont:definition.font
							   constrainedToSize:maximumSize 
								   lineBreakMode:definition.lineBreakMode];
	
    CGRect defFrame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width, defStringSize.height);
	
    definition.frame = defFrame;
	definition.text = defText;
}

- (void)update{
	[self updateWord];
	[self updateScore];
	[self updateTime];
}

- (void)updateWord {
	[self setDefinitionLabelText: game.curWord.definition];
	word.text = [game.curWord.word substringToIndex:1];
	[word becomeFirstResponder];
}

- (void)updateScore {
	scoreLabel.text = [NSString stringWithFormat:@"%d", game.points];
}

- (void)updateTime {
	NSNumberFormatter *secs = [[NSNumberFormatter alloc] init];
	[secs setFormatWidth:2];
	[secs setPaddingCharacter:@"0"];
	timerLabel.text = [NSString stringWithFormat:@"%d:%@", game.time / 60, [secs stringFromNumber:[NSNumber numberWithInt:game.time % 60]]];
	[secs release];
}

- (void)startWaiting {
	[spinner startAnimating];
	[self setDefinitionLabelText: @""];
	word.text = @"";
}

- (void)stopWaiting {
	[spinner stopAnimating];
	[self updateWord];
}

- (void)finishGame {
	[UIAppDelegate finishGame];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
