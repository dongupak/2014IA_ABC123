/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"
#import "GameLayer.h"
#import "DataManager.h"
#import "MenuLayer.h"

@interface GameScene : Scene
{
	GameLayer *mainLayer;
	MenuLayer *menuLayer;
	DataManager *dataManager;
}

@property (nonatomic, retain) GameLayer *mainLayer;
@property (nonatomic, retain) MenuLayer *menuLayer;
@property (nonatomic, retain) DataManager *dataManager;

@end
