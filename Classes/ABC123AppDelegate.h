/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import <UIKit/UIKit.h>
#import "NameEntryViewController.h"
#import "WebViewController.h"
#import "HighScoresViewController.h"

@interface ABC123AppDelegate : NSObject <UIApplicationDelegate>
{
	NSNotificationCenter *notifyCenter;
	NameEntryViewController *nameEntry;
	WebViewController *webViewController;
	HighScoresViewController *highScoresViewController;
}

@property (nonatomic, retain) NSNotificationCenter *notifyCenter;
@property (nonatomic, retain) NameEntryViewController *nameEntry;
@property (nonatomic, retain) WebViewController *webViewController;
@property (nonatomic, retain) HighScoresViewController *highScoresViewController;

- (void) loadHtml:(NSString *) name withTitle:(NSString *) title;
- (void) hideUIViewController:(UIViewController *) controller;
- (void) showUIViewController:(UIViewController *) controller;

@end

