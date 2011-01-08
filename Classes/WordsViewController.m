//
//  WordsViewController.m
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "WordsViewController.h"

@implementation WordsViewController

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

- (void)getNewWords {
	[connection newConnectionWithURL:
	 [NSURL URLWithString: @"http://www.david-stalnaker.com/words/getWords.php"]];
}

- (IBAction)testWord{
	if ([[word text] isEqualToString:curWord.word]) {
		[self gotWordCorrect];
	}
}

- (IBAction)skipWord {
	[self addPoints:-20];
	[self setNewWord];
}

- (void)gotWordCorrect {
	[self addPoints:50];
	[self addTime:5];
	[self setNewWord];
}

- (void)setNewWord {
	curWord = [newWords lastObject];
	[newWords removeLastObject];
	[self setDefinitionLabelText: curWord.definition];
	word.text = [curWord.word substringToIndex:1];
}

- (void)addPoints:(int)numPoints {
	points += numPoints;
	scoreLabel.text = [NSString stringWithFormat:@"%d", points];
}

- (void)addTime:(int)numSecs {
	time += numSecs;
	NSNumberFormatter *secs = [[NSNumberFormatter alloc] init];
	[secs setFormatWidth:2];
	[secs setPaddingCharacter:@"0"];
	timerLabel.text = [NSString stringWithFormat:@"%d:%@", time / 60, [secs stringFromNumber:[NSNumber numberWithInt:time % 60]]];
}

- (void)tick {
	if(time <= 0) {
		[self stopTimer];
	}
	else {
		[self addTime:-1];
	}
}

- (void)resetTimer {
	time = 60;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											 target:self 
										   selector:@selector(tick)
										   userInfo:nil
											repeats:YES];
}

- (void)stopTimer {
	[timer invalidate];
}

- (void)startTimer {
	
}

- (void)finishedLoading:(NSMutableData*)data {
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSMutableArray* decoded = [parser objectWithString: jsonString];
	NSLog(@"%@", decoded);
	for (NSMutableDictionary* elem in decoded) {
		[newWords addObject:[[Word alloc] initWithWord:[[elem valueForKey:@"word"] copy]
											definition:[[elem valueForKey:@"definition"] copy]]];
	}
	[self setNewWord];
	[word becomeFirstResponder];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	connection = [[WebConnection alloc] initWithDelegate:self];
	
	points = 0;
	
	newWords = [[NSMutableArray alloc] initWithCapacity:20];
	pastWords = [[NSMutableArray alloc] initWithCapacity:20];
	
	[self getNewWords];
	
	
	[self resetTimer];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
