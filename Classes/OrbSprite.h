/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "cocos2d.h"

// Sprite를 상속받은 OrbSprite 클래스
// 거품처럼 잠시 나타나면서 사라지는 스프라이트  
@interface OrbSprite : Sprite
{
	// 속성으로 레이블, 버블, 객체의 hidden, bubble속성, 순서정보 등이 있다.
	Label *label;
	Animation *bubble;
	BOOL isBubble;
	BOOL isHidden;
	int order;
	
	Sequence *popSequence;
}

// 각각의 property 선언 
@property (nonatomic, retain) Label *label;
@property (nonatomic, retain) Sequence *popSequence;
@property (nonatomic, retain) Animation *bubble;
// BOOL, int 형은 readwrite 옵션으로 setter, getter생성 
@property (readwrite) BOOL isBubble;
@property (readwrite) BOOL isHidden;
@property (readwrite) int order;

- (void) pop;
- (void) setLabelStr:(NSString *) str;
- (void) showBubble;
- (void) reset;

@end
