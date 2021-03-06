//
//  Game.h
//  Words
//
//  Created by David Stalnaker on 1/9/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "JSON/JSON.h"
#import "WebConnection.h"
#import "GameObserver.h"


@interface Game : NSObject <WebConnectionDelegate> {
	WebConnection *connection;
	id <GameObserver> observer;
	
	NSMutableArray *newWords;
	Word *curWord;
	NSMutableArray *pastWords;
	
	NSTimer *timer;
	BOOL waitingOnData;
	BOOL openConnection;
	int time;
	int points;
	
	int numWordsPerConnection;
}

- (id)initWithObserver:(id <GameObserver>)obs;
- (void)newGame;

- (void)testWord:(NSString *)word;
- (void)skipWord;
- (void)gotWordCorrect;
- (void)getNewWords;
- (void)setNewWord;

- (void)startTimer;
- (void)stopTimer;
- (void)resetTimer;
- (void)tick;

- (void)finishedLoading:(NSMutableData*)data;

@property (readwrite, copy) Word *curWord;
@property (readwrite, assign) int time;
@property (readwrite, assign) int points;

@end
