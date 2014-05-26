/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "MenuLayer.h"

@implementation MenuLayer

@synthesize menu, delegate;
@synthesize background;

- (void) dealloc
{
	[background release];
	[delegate release];
	[menu release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		Sprite *back = [[Sprite alloc] initWithFile:@"menu.png"];
		self.background = back;
		[back release];
		
		background.transformAnchor = cpv(0, 0);
		
		[self addChild:background];
		
		[MenuItemFont setFontSize:25];
        [MenuItemFont setFontName:@"Marker Felt"];
		
        MenuItem *start = [MenuItemFont itemFromString:@"Start Game"
												target:self
											  selector:@selector(restartGame:)];
		
		MenuItem *moreGames = [MenuItemFont itemFromString:@"Random Apps"
												target:self
											  selector:@selector(moreGames:)];
		
		MenuItem *scores = [MenuItemFont itemFromString:@"Top Ten"
													target:self
												  selector:@selector(highScores:)];
		
		MenuItem *about = [MenuItemFont itemFromString:@"About"
													target:self
												  selector:@selector(about:)];
		
		menu = [Menu menuWithItems:start, [MenuLayer getSpacerItem], 
				moreGames, [MenuLayer getSpacerItem], 
				scores, [MenuLayer getSpacerItem], 
				about, nil];
		
        [menu alignItemsVertically];
        [self addChild:menu];
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Selector Methods /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (void) about:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"about" object:@""];
}

- (void) highScores:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"highScores" object:@""];
}

- (void) moreGames:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"moreGames" object:@""];
}

///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Delegate Methods /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (void) restartGame:(id) sender
{
	if ([self.delegate respondsToSelector:@selector(restartGame)]) 
	{
		[self.delegate restartGame];
	}
}

+ (MenuItemFont *) getSpacerItem
{
	[MenuItemFont setFontSize:2];
	return [MenuItemFont itemFromString:@" " target:self selector:nil];
}

@end
