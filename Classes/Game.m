//
//  Game.m
//  Words
//
//  Created by David Stalnaker on 1/9/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import "Game.h"


@implementation Game

#pragma mark Synthesis

@synthesize curWord;

- (void)setTime:(int)t {
	time = t;
	[observer updateTime];
}

- (int)time {
	return self->time;
}

- (void)setPoints:(int)p {
	points = p;
	[observer updateScore];
}

- (int)points {
	return self->points;
}

#pragma mark Lifecycle

- (id)initWithObserver:(id <GameObserver>)obs {
	self = [super init];
	if(self) {
		connection = [[WebConnection alloc] initWithDelegate:self];	
		observer = obs;
		
		newWords = [[NSMutableArray alloc] initWithCapacity:20];
		pastWords = [[NSMutableArray alloc] initWithCapacity:20];
		
		waitingOnData = NO;
		openConnection = NO;
		
		self.time = 60;
		self.points = 0;
		
		numWordsPerConnection = 10;
		
		[self getNewWords];
		[observer startWaiting];
	}
	return self;
}

- (void)newGame{
	self.points = 0;
	self.time = 60;
	if(!openConnection) {
		[self setNewWord];
		[self startTimer];
	}
	else {
		waitingOnData = YES;
		[observer startWaiting];
	}
}

#pragma mark Gameplay

- (void)testWord:(NSString *)word{
	if ([word isEqualToString:curWord.word]) {
		[self gotWordCorrect];
	}
}

- (void)skipWord {
	self.points -= 20;
	[self setNewWord];
}


- (void)gotWordCorrect {
	self.points += 50;
	self.time += 5;
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

#pragma mark Timer

- (void)tick {
	if(self.time <= 0) {
		[self stopTimer];
		[observer finishGame];
	}
	else {
		self.time--;
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
	self.time = 60;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											 target:self 
										   selector:@selector(tick)
										   userInfo:nil
											repeats:YES];
}

#pragma mark GameObserver

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
