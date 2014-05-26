/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"
#import "DataManager.h"
#import "OrbSprite.h"
#import "MessageNode.h"

@interface NSObject (GameLayerDelegate)

- (void) nextLevel;
- (void) restartGame;
- (void) endGame;

@end

// 게임 레이어로 실제 게임에서 활용되는 text, sprite등의 선언이 이루어짐
// 
@interface GameLayer : Layer
{
	id delegate;
	LabelAtlas *scoreLabel;
	LabelAtlas *missesLabel;
	// orbArray는 OrbSprite들의 MutableArray임
	NSMutableArray *orbArray;
	DataManager *dataManager;
	Sprite *background;
	Sprite *statusBar;
	Sprite *spriteHolder;
	MessageNode *message;
	
	int lastIndex;
	BOOL levelStarted;
	
	Menu *endMenu;
	MenuItemToggle *toggleItem;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) LabelAtlas *scoreLabel;
@property (nonatomic, retain) LabelAtlas *missesLabel;
@property (nonatomic, retain) NSMutableArray *orbArray;
@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) Sprite *background;
@property (nonatomic, retain) Sprite *statusBar;
@property (nonatomic, retain) Sprite *spriteHolder;
@property (nonatomic, retain) MessageNode *message;
@property (nonatomic, retain) Menu *endMenu;
@property (nonatomic, retain) MenuItemToggle *toggleItem;

- (void) setScore:(int) score;
- (void) setMisses:(int) miss;
- (void) loadLevel:(NSArray *) level;

@end
