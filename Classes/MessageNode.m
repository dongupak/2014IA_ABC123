/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "MessageNode.h"

@implementation MessageNode

int const MISS_MESSAGE = 0;
int const PERFECT_MESSAGE = 1;
int const CORRECT_MESSAGE = 2;

@synthesize miss, perfect, correct;

- (void) dealloc
{
	[correct release];
	[miss release];
	[perfect release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		Sprite *m = [[Sprite alloc] initWithFile:@"miss.png"];
		self.miss = m;
		[m release];
		
		miss.transformAnchor = cpv(0, 0);
		
		[self addChild:miss];
		
		Sprite *p = [[Sprite alloc] initWithFile:@"perfect.png"];
		self.perfect = p;
		[p release];
		
		[self addChild:perfect];
		
		perfect.transformAnchor = cpv(0, 0);
		
		Sprite *c = [[Sprite alloc] initWithFile:@"correct.png"];
		self.correct = c;
		[c release];
		
		[self addChild:correct];
		
		correct.transformAnchor = cpv(0, 0);
		
		miss.position = cpv(0, -20);
		perfect.position = cpv(0, -20);
		
		[correct runAction:[FadeOut actionWithDuration:.01]];
		[perfect runAction:[FadeOut actionWithDuration:.01]];
		[miss runAction:[FadeOut actionWithDuration:.01]];
	}
	
	return self;
}

- (void) showMessage:(int) message
{
	Sprite *sprite;
	
	if(message == MISS_MESSAGE)
	{
		sprite = miss;
		missVisible = YES;
	}else if(message == CORRECT_MESSAGE)
	{
		sprite = correct;
		correctVisible = YES;
	}else if(message == PERFECT_MESSAGE)
		sprite = perfect;
	
	// 스프라이트에 대한 액션으로 0.01초 동안 FadeTo를 통해 투명하게 만든다.
	[sprite runAction:[FadeTo actionWithDuration:.01 opacity:0]];
		
	// 투명한 상태의 스프라이트에 대하여 순차적인 액션을 수행함..
	[sprite runAction:[Sequence actions:
				[FadeTo actionWithDuration:.1 opacity:250],  // 화면에 서서히 보여줌.
				[DelayTime actionWithDuration:.5],			// 잠시 기다림
				[FadeTo actionWithDuration:.1 opacity:0], nil]];  // 화면에서 사라짐.
}

@end
