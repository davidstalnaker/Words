//
//  MainWindowController.h
//  Words
//
//  Created by David Stalnaker on 1/8/11.
//  Copyright 2011 David Stalnaker. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController {
	IBOutlet UILabel *score;
}

- (IBAction)startGame;
- (void)updateScore:(int)s;

@end
