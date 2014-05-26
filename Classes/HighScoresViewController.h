/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet UITableView *table;
	UIActivityIndicatorView *activityIndicator;
	
	DataManager *dataManager;
	BOOL connected;
	
	NSMutableArray *globalScores;
}

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) NSMutableArray *globalScores;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (IBAction) cancel;

@end
