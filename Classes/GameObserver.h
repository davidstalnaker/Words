//
//  GameObserver.h
//  Words
//
//  Created by David Stalnaker on 1/9/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GameObserver <NSObject>
- (void) updateWord;
- (void) updateTime;
- (void) updateScore;
- (void) startWaiting;
- (void) stopWaiting;
- (void) finishGame;
@end
