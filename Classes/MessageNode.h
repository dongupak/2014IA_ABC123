/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"

// 메시지를 화면에 촐력함 
@interface MessageNode : CocosNode
{
	Sprite *miss;
	Sprite *perfect;
	Sprite *correct;
	
	BOOL missVisible;
	BOOL correctVisible;
}

extern int const MISS_MESSAGE;
extern int const PERFECT_MESSAGE;
extern int const CORRECT_MESSAGE;

@property (nonatomic, retain) Sprite *miss;
@property (nonatomic, retain) Sprite *perfect;
@property (nonatomic, retain) Sprite *correct;

- (void) showMessage:(int) message;

@end
