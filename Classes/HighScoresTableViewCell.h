/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <UIKit/UIKit.h>

@interface HighScoresTableViewCell : UITableViewCell
{
	IBOutlet UIImageView *number;
	IBOutlet UILabel *globalBest;
}

@property (nonatomic, retain) IBOutlet UIImageView *number;
@property (nonatomic, retain) IBOutlet UILabel *globalBest;

- (void) initStyle;

@end
