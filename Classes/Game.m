//
//  Game.m
//  Words
//
//  Created by David Stalnaker on 1/9/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize curWord;
@synthesize time;
@synthesize points;

- (id)initWithObserver:(id <GameObserver>)obs {
	self = [super init];
	if(self) {
		connection = [[WebConnection alloc] initWithDelegate:self];	
		observer = obs;
		
		newWords = [[NSMutableArray alloc] initWithCapacity:20];
		pastWords = [[NSMutableArray alloc] initWithCapacity:20];
		
		waitingOnData = NO;
		openConnection = NO;
		
		time = 60;
		points = 0;
		
		numWordsPerConnection = 10;
		
		[self getNewWords];
		waitingOnData = YES;
		[observer startWaiting];
	}
	return self;
}

- (void)testWord:(NSString *)word{
	if ([word isEqualToString:curWord.word]) {
		[self gotWordCorrect];
	}
}

- (void)skipWord {
	[self addPoints:-20];
	[self setNewWord];
}


- (void)gotWordCorrect {
	[self addPoints:50];
	[self addTime:5];
	[self setNewWord];
}

- (void)getNewWords {
	if(!openConnection) {
		openConnection = YES;
		NSString *postData = [NSString stringWithFormat:@"numWords=%d", numWordsPerConnection];
		[connection newConnectionWithURL:
		 [NSURL URLWithString: @"http://www.david-stalnaker.com/words/getWords.php"]
							 andPostData:
		 [postData dataUsingEncoding:NSUTF8StringEncoding]];
	}
}


- (void)setNewWord {
	if([newWords count] < numWordsPerConnection / 2) {
		[self getNewWords];
	}
	if([newWords count] > 0) {
		if(curWord) {
			[pastWords addObject:curWord];	
		}
		curWord = [newWords lastObject];
		[newWords removeLastObject];
		[observer updateWord];
	}
	else {
		waitingOnData = YES;
		[observer startWaiting];
		[self stopTimer];
	}
}

- (void)addPoints:(int)numPoints {
	points += numPoints;
	[observer updateScore];
}

- (void)addTime:(int)numSecs {
	time += numSecs;
	[observer updateTime];
}

- (void)tick {
	if(time <= 0) {
		[self stopTimer];
	}
	else {
		[self addTime:-1];
	}
}

- (void)startTimer {
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											 target:self 
										   selector:@selector(tick)
										   userInfo:nil
											repeats:YES];
}

- (void)stopTimer {
	[timer invalidate];
	timer = nil;
}

- (void)resetTimer {
	time = 60;
	[observer updateTime];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											 target:self 
										   selector:@selector(tick)
										   userInfo:nil
											repeats:YES];
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
	if(waitingOnData) {
		[self setNewWord];
		[observer stopWaiting];
		[self startTimer];
	}
	openConnection = NO;
	waitingOnData = NO;
	
	[jsonString release];
	[parser release];
}

@end
