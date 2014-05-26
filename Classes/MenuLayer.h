/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"

@interface NSObject (MenuLayerDelegate)

- (void) restartGame;

@end

@interface MenuLayer : Layer
{
	Menu *menu;
	id delegate;
	
	Sprite *background;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) Menu *menu;
@property (nonatomic, retain) Sprite *background;

+ (MenuItemFont *) getSpacerItem;

@end
