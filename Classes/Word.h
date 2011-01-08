//
//  Word.h
//  Words
//
//  Created by David Stalnaker on 1/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Word : NSObject {
	NSString *word;
	NSString *definition;
}

- (id)init;

- (id)initWithWord:(NSString*) word
		definition:(NSString*) definition;

@property (readwrite, copy) NSString *word;
@property (readwrite, copy) NSString *definition;

@end
