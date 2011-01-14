//
//  Word.m
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import "Word.h"


@implementation Word
@synthesize word;
@synthesize definition;

- (id)init {
	[super init];
	
	return self;
}

- (id)initWithWord:(NSString*)w
		definition:(NSString*)d {
	word = w;
	definition = d;
	return self;
}

@end
