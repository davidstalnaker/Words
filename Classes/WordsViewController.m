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
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	connection = [[WebConnection alloc] initWithDelegate:self];
	
	points = 0;
	
	[self getNewWords];
	
	newWords = [[NSMutableArray alloc] initWithCapacity:20];
	pastWords = [[NSMutableArray alloc] initWithCapacity:20];
	
	[newWords addObject:[[Word alloc] initWithWord:@"amnesty" definition:@"An official pardon for people who have been convicted of political offenses"]];
	[newWords addObject:[[Word alloc] initWithWord:@"hunger" definition:@"A feeling of discomfort or weakness caused by lack of food, coupled with the desire to eat"]];
	[newWords addObject:[[Word alloc] initWithWord:@"pajamas" definition:@"A suit of loose pants and jacket or shirt for sleeping in"]];
	[newWords addObject:[[Word alloc] initWithWord:@"seriously" definition:@"In a solemn or considered manner"]];
	[newWords addObject:[[Word alloc] initWithWord:@"flower" definition:@"A brightly colored and conspicuous example of such a part of a plant together with its stalk, typically used with others as a decoration or gift"]];
	[newWords addObject:[[Word alloc] initWithWord:@"enlist" definition:@"Enroll or be enrolled in the armed services"]];
	[newWords addObject:[[Word alloc] initWithWord:@"logical" definition:@"Characterized by clear, sound reasoning"]];
	[newWords addObject:[[Word alloc] initWithWord:@"attachment" definition:@"An extra part or extension that is or can be attached to something to perform a particular function"]];
	[newWords addObject:[[Word alloc] initWithWord:@"classic" definition:@"Judged over a period of time to be of the highest quality and outstanding of its kind"]];
	[newWords addObject:[[Word alloc] initWithWord:@"rag" definition:@"A piece of old cloth, esp. one torn from a larger piece, used typically for cleaning things"]];
	[newWords addObject:[[Word alloc] initWithWord:@"film" definition:@"A thin flexible strip of plastic or other material coated with light-sensitive emulsion for exposure in a camera, used to produce photographs or motion pictures"]];
	[newWords addObject:[[Word alloc] initWithWord:@"shelf" definition:@"A flat length of wood or rigid material, attached to a wall or forming part of a piece of furniture, that provides a surface for the storage or display of objects"]];
	[newWords addObject:[[Word alloc] initWithWord:@"resume" definition:@"Begin to do or pursue (something) again after a pause or interruption"]];
	[newWords addObject:[[Word alloc] initWithWord:@"flexibility" definition:@"The quality of bending easily without breaking"]];
	[newWords addObject:[[Word alloc] initWithWord:@"consent" definition:@"Give permission for something to happen"]];
	[newWords addObject:[[Word alloc] initWithWord:@"editor" definition:@"A person who is in charge of and determines the final content of a text, particularly a newspaper or magazine"]];
	[newWords addObject:[[Word alloc] initWithWord:@"shower" definition:@"An enclosure in which a person stands under a spray of water to wash"]];
	[newWords addObject:[[Word alloc] initWithWord:@"choice" definition:@"A course of action, thing, or person that is selected or decided upon"]];
	[newWords addObject:[[Word alloc] initWithWord:@"building" definition:@"A structure with a roof and walls, such as a house, school, store, or factory"]];
	[newWords addObject:[[Word alloc] initWithWord:@"parallel" definition:@"(of lines, planes, surfaces, or objects) Side by side and having the same distance continuously between them"]];
	
	[self setNewWord];
	[word becomeFirstResponder];
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
