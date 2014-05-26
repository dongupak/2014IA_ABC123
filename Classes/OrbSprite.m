/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "OrbSprite.h"

@implementation OrbSprite

@synthesize bubble;
@synthesize label;
@synthesize isBubble;
@synthesize isHidden;
@synthesize popSequence;
@synthesize order;

// retain 속성의 객체들은 release가 필요함
- (void) dealloc
{
	[popSequence release];
	[label release];
	[bubble release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		[self initWithFile:@"bubble1.png"];
		// 애니메이션 객체 bub는 bubble1.png에서 bubble2.png로의 애니메이션을 생성
		// bubble1.png : 45x45의 빈 이미지
		// bubble2.png : 47x47의 bubble 이미지임 
		Animation *bub = [Animation animationWithName:@"bubble" delay:0 
											   images:@"bubble1.png", @"bubble2.png", nil];
		self.bubble = bub;
		[bub release];
		
		// OrbSprite에 애니메이션을 추가함 
		[self addAnimation:bubble];
		
		// OrbSprite에서 사용할 레이블의 속성 지정
		Label *l = [[Label alloc] initWithString:@"" 
									  dimensions:CGSizeMake(45, 45) 
									   alignment:UITextAlignmentCenter 
										fontName:@"Arial Rounded MT Bold" 
										fontSize:18];
		self.label = l;
		[l release];
	}
	
	return self;
}

// 화면에서 터지는 장면이 pop될때 하는 일
// ScaleTo 객체를 이용한 순차적 애니메이션인 Sequence를 생성함
- (void) pop
{
	isBubble = NO;
	
	// actionWithDuration에서 0.1초간 scale을 .5로 하여 축소시킨 후 0.1초간 2배 확대
	// 여기서도 전체 애니메이션 시퀀스가 실행되는 시간은 0.2 (0.1+0.1)초에 불과
	popSequence = [Sequence actions:
				   [ScaleTo actionWithDuration:.1 scale:.5],
				   [ScaleTo actionWithDuration:.1 scale:2], 
				   // sequence내의 CallFunc는 잘 이해가 안된다..
				   // Sequence에 의해 순차적으로 액션이 수해됨
				   // 그리고 제일 마지막에 selector에 있는 메소드가 호출됨
				   [CallFunc actionWithTarget:self selector:@selector(finishedPopSequence)], 
				   nil];
	[self runAction:popSequence];
}

// 종료된 pop Sequence
- (void) finishedPopSequence
{
	self.scale = 1;
	[self setDisplayFrame:@"bubble" index:0];
}

- (void) reset
{
	self.scale = 1;
	[self setDisplayFrame:@"bubble" index:0];
}

// 화면에 bubble이 나타날 때 하는 일 
- (void) showBubble
{
	// isBubble 부울 값을 YES로
	isBubble = YES;
	// 레이블을 지우고 cleanup은 하지 않는다.. 메모리에는 상주함 
	[self removeChild:label cleanup:NO];
	[self setDisplayFrame:@"bubble" index:1];
	self.scale = .5;
	// 0.1초간 1.5로 키웠다가 원래 크기로 돌아감
	// 전체 모양이 나타나는 애니메이션 시퀀스의 기간은 .2초에 불과함. 
	[self runAction:[Sequence actions:
					 [ScaleTo actionWithDuration:.1 scale:1.5], 
					 [ScaleTo actionWithDuration:.1 scale:1], nil]];
}

- (void) setLabelStr:(NSString *) str
{
	[label setString:str];
	[self addChild:label];
	
	label.transformAnchor = cpv(0, 13);
}

@end
