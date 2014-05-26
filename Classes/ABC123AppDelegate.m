/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "ABC123AppDelegate.h"
#import "GameScene.h"
#import "cocos2d.h"

@implementation ABC123AppDelegate

@synthesize notifyCenter, nameEntry, webViewController, highScoresViewController;

- (void)dealloc
{
	[highScoresViewController release];
	[webViewController release];
	[nameEntry release];
	[notifyCenter release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
	// notifyCenter는 observer로 등록되어 있다가 메뉴의 각 항목이 선택되면 이를 수행하는 역할을 한다
	self.notifyCenter = [NSNotificationCenter defaultCenter];
	[notifyCenter addObserver:self selector:@selector(trackNotifications:) 
						 name:nil object:nil];
	
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
	
    [[Director sharedDirector] attachInWindow:window];
	
    [window makeKeyAndVisible];
	
	// 게임 신 객체를 만들어 이 객체를 Director의 running Scene으로 둔다.
	GameScene *gs = [GameScene node];
    [[Director sharedDirector] runWithScene:gs];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
    [[Director sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [[Director sharedDirector] resume];
}

-(void) applicationWillTerminate: (UIApplication*) application
{
    [[Director sharedDirector] release];
}

- (void) trackNotifications: (NSNotification *) notification
{
	id nname = [notification name];
	
	if([nname isEqual:@"about"])
	{
		[self loadHtml:@"about" withTitle:@"About"];
	}else if([nname isEqual:@"highScores"])
	{
		HighScoresViewController *high = [[HighScoresViewController alloc] init];
		self.highScoresViewController = high;
		[high release];

		[self showUIViewController:highScoresViewController];
		
	}else if([nname isEqual:@"removeHighScores"])
	{
		[self hideUIViewController:highScoresViewController];
		
		[highScoresViewController release];
		highScoresViewController = nil;
	}else if([nname isEqual:@"moreGames"])
	{
		[self loadHtml:@"games" withTitle:@"Games"];
	}else if([nname isEqual:@"newHighScore"])
	{
		NameEntryViewController *entry = [[NameEntryViewController alloc] init];
		self.nameEntry = entry;
		[entry release];

		[self showUIViewController:nameEntry];
	}else if([nname isEqual:@"removeNameEntry"])
	{
		[self hideUIViewController:nameEntry];
		
		[nameEntry release];
		nameEntry = nil;
	}else if([nname isEqual:@"removeWebView"])
	{
		[self hideUIViewController:webViewController];
		
		[webViewController release];
		webViewController = nil;
	}
}

- (void) loadHtml:(NSString *) name withTitle:(NSString *) title
{
	WebViewController *web = [[WebViewController alloc] init];
	self.webViewController = web;
	[web release];
	
	[self showUIViewController:webViewController];
	
	[webViewController loadHtml:name withTitle:title];
}

-(void)animDone:(NSString*) animationID finished:(BOOL)finished context:(void*)context
{	
	[[Director sharedDirector] resume];
}

- (void) showUIViewController:(UIViewController *) controller
{
	[[Director sharedDirector] pause];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
						   forView:[[Director sharedDirector] openGLView] cache:YES];
	
	[[[Director sharedDirector] openGLView] addSubview:controller.view];
	
	[UIView commitAnimations];
}

- (void) hideUIViewController:(UIViewController *) controller
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animDone:finished:context:)];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
						   forView:[[Director sharedDirector] openGLView] cache:YES];
	
	[controller.view removeFromSuperview];
	
	[UIView commitAnimations];
}

@end
