/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "GameLayer.h"
#import "MenuLayer.h"

#define bubbleWidth 47
#define topUIHeight 30

@interface GameLayer (Private)
	
- (void) arrangeUI;
- (CGPoint) getRandomPointWithMaxIndex:(int) index;
- (void) arrangeOrbs:(int) orbs;
- (void) hideOrbs;
- (void) showEndGame;
- (void) checkForOrbTap:(CGPoint) touch;
- (BOOL) circle:(CGPoint) circlePoint withRadius:(float) radius collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo;
	
@end

@implementation GameLayer

// GameLayer에서 사용되는 attribute 값들.
@synthesize delegate;
@synthesize scoreLabel, missesLabel;
@synthesize orbArray;
@synthesize dataManager;
@synthesize background;
@synthesize endMenu;
@synthesize toggleItem;
@synthesize statusBar;
@synthesize message;
@synthesize spriteHolder;

- (void) dealloc
{
	[spriteHolder release];
	[message release];
	[statusBar release];
	[toggleItem release];
	[missesLabel release];
	[background release];
	[dataManager release];
	[orbArray release];
	[scoreLabel release];
	[endMenu release];
	[delegate release];
	[super dealloc];
}

// GameLayer 속성 오브젝트들의 초기화수행
-(id) init
{
	self = [super init];
	
	if (self)
	{
		// 초기화 및 설정
		self.isTouchEnabled = YES;
		dataManager = [DataManager sharedManager];
		
		// 배경 스프라이트 설정
		Sprite *back = [[Sprite alloc] initWithFile:@"background.png"];
		self.background = back;
		[back release];
		background.transformAnchor = cpv(0, 0);
		[self addChild:background];
		
		// 상태표시줄, 여러 레이블 설정 등 
		Sprite *status = [[Sprite alloc] initWithFile:@"statusBar.png"];
		self.statusBar = status;
		[status release];
		statusBar.transformAnchor = cpv(0, 0);
		[self addChild:statusBar];
		
		LabelAtlas *label = [[LabelAtlas alloc] initWithString:@"0" 
												   charMapFile:@"numbers.png" 
													 itemWidth:11 
													itemHeight:16 
												  startCharMap:'.'];
		self.scoreLabel = label;
		[label release];
		[self addChild:scoreLabel];
		
		LabelAtlas *label2 = [[LabelAtlas alloc] initWithString:@"0" 
													charMapFile:@"numbers.png" 
													  itemWidth:11 
													 itemHeight:16 
												   startCharMap:'.'];
		self.missesLabel = label2;
		[label2 release];
		[self addChild:missesLabel];
		
		Sprite *sh = [[Sprite alloc] init];
		self.spriteHolder = sh;
		[sh release];
		spriteHolder.transformAnchor = cpv(0, 0);
		[self addChild:spriteHolder];
		
		MessageNode *mess = [[MessageNode alloc] init];
		self.message = mess;
		[mess release];
		message.transformAnchor = cpv(0, 0);
		[self addChild:message];
		
		// orbSprite를 위한 MutableArray
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.orbArray = array;
		[array release];
		[self arrangeUI];
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// Collision Detection ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)circle:(CGPoint)circlePoint withRadius:(float)radius 
	collisionWithCircle:(CGPoint) circlePointTwo collisionCircleRadius:(float) radiusTwo
{
	float xdif = circlePoint.x - circlePointTwo.x;
	float ydif = circlePoint.y - circlePointTwo.y;
	// 두점 사이의 거리를 구한다.
	float distance = sqrt(xdif*xdif+ydif*ydif);
	
	// 두 점의 반지름의 합을 구하여 이 값보다 거리가 작으면 충돌이 발생
	// 따라서 YES를 반환한다.
	if(distance <= radius+radiusTwo) 
		return YES;
	
	return NO;
}

// 
- (void) checkForOrbTap:(CGPoint) touch
{
	int i;
	
	for(i = 0; i < [orbArray count]; i++)
	{
		OrbSprite *sprite = (OrbSprite *)[orbArray objectAtIndex:i];
		
		if(!sprite.isHidden)
		{
			BOOL spriteTapped = [self circle:touch 
								  withRadius:1 
						 collisionWithCircle:CGPointMake(sprite.position.x, sprite.position.y) 
					   collisionCircleRadius:bubbleWidth/2];
			
			// 스프라이트가 선택되었고 이 스프라이트가 순서에 맞게 선택된 것이라면 
			if(spriteTapped && sprite.order == dataManager.currentindex)
			{
				// dataManager의 현재 인덱스를 하나 증가시킴, 점수도 증가함
				dataManager.currentindex += 1;
				dataManager.score += 1;
				
				// message노드에 CORRECT_MESSAGE를 전달.
				[message showMessage:CORRECT_MESSAGE];
				// 스프라이트를 pop시킨다.
				[sprite pop];
				
				// 만일 sprite의 순서가 마지막이면 다음 레벨로 이동한다.
				if(sprite.order == lastIndex-1)
					[self runAction:[Sequence 
									 actions:[DelayTime actionWithDuration:.2], 
									 [CallFunc actionWithTarget:self 
													   selector:@selector(nextLevel)], 
									 nil]];
					
			}
			else if(spriteTapped)
			{
				// 잘못 탭한 경우 점수가 깎이고 miss값이 0이면 게임 종료 
				dataManager.missed = YES;
				dataManager.score -= 1;
				dataManager.misses -= 1;
				
				[message showMessage:MISS_MESSAGE];
				
				if(dataManager.misses == 0)
				{
					[self hideOrbs];
					[self showEndGame];
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Display Methods /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// 사용자 인테페이스..
- (void) arrangeUI
{
	scoreLabel.position = cpv(5, 460);
	statusBar.position = cpv(0, 455);
	message.position = cpv(0, 380);
}

// 게임 종료 화면.
- (void) showEndGame
{
	if(endMenu == nil)
	{
		[MenuItemFont setFontSize:25];
        [MenuItemFont setFontName:@"Marker Felt"];
		
		MenuItem *restart = [MenuItemFont itemFromString:@"Restart"
											   target:self
											 selector:@selector(restartGame:)];
		
		MenuItem *more = [MenuItemFont itemFromString:@"Random Apps"
												  target:self
												selector:@selector(moreGames:)];
		
		MenuItem *submit = [MenuItemFont itemFromString:@"Submit Score"
											  target:self
											selector:@selector(submitScore:)];
		
		MenuItem *high = [MenuItemFont itemFromString:@"Top Ten"
												 target:self
											   selector:@selector(highScores:)];
		
		endMenu = [[Menu menuWithItems:submit, 
					[MenuLayer getSpacerItem], 
					restart, 
					[MenuLayer getSpacerItem], 
					high, 
					[MenuLayer getSpacerItem], 
					more, nil] retain];
		
		[endMenu alignItemsVertically];
	}
	
	if(dataManager.currentlevel == [dataManager.levels count]-1  && !dataManager.missed)
		toggleItem.selectedIndex = 1;
	else
		toggleItem.selectedIndex = 0;
	
	[self addChild:endMenu];
}

// 인덱스 정보를 이용 랜덤하게 점을 표시한다.
- (CGPoint) getRandomPointWithMaxIndex:(int) index
{
	int i;
	
	float randomX = (arc4random() % (320 - bubbleWidth) + bubbleWidth/2);
	float randomY = (arc4random() % (480 - (topUIHeight + bubbleWidth)) + (bubbleWidth/2));
	
	CGPoint ranPoint = CGPointMake(randomX, randomY);
	
	for(i = 0; i < index; i++)
	{
		// testing을 위한 OrbSprite로 기존의 스프라이트와 충돌이 없는지 검사를 위하여 사용
		OrbSprite *testOrb = (OrbSprite *) [orbArray objectAtIndex:i];
		
		BOOL collision = [self circle:ranPoint 
						   withRadius:bubbleWidth/2 
				  collisionWithCircle:CGPointMake(testOrb.position.x, testOrb.position.y) 
				collisionCircleRadius:bubbleWidth/2];
		
		// 기존의 점과 충돌이 있을경우 다시 점을 찍어준다.
		// recursion 모듈..
		if(collision) 
			ranPoint = [self getRandomPointWithMaxIndex:index];
	}
	
	return ranPoint;
}

- (void) arrangeOrbs:(int) orbs
{
	lastIndex = orbs;
	
	int i;
	for(i = 0; i < orbs; i++)
	{
		OrbSprite *sprite = (OrbSprite *) [orbArray objectAtIndex:i];
		
		// 각 sprite들의 랜덤 포인터 좌표를 구한 후
		// 이 좌표를 sprite의 위치로 지정한다.
		CGPoint point = [self getRandomPointWithMaxIndex:i];
		sprite.position = cpv(point.x, point.y);
		
		// sprite의 Hidden속성은 NO 따라서 화면에 뿌려진다.
		sprite.isHidden = NO;
		
		// spriteHodler의 자식으로 sprite를 달아준다.
		[self.spriteHolder addChild:sprite];
	}
}

// Orbit Sprite를 숨기는 메소드
- (void) hideOrbs
{
	int i;
	for(i = 0; i < [orbArray count]; i++)
	{
		// 모든 스프라이트를 reset시키고 Hidden 속성을 YES로 하여 숨기기 
		OrbSprite *sprite = (OrbSprite *) [orbArray objectAtIndex:i];
		[sprite reset];
		sprite.isHidden = YES;
		// 스프라이트 홀더가 스프라이트를 자식노드에서 제거함
		// ?? 제거할 것을 왜 reset시키고 hidden으로 하였을까?
		// 답 : cleanup 속성이 NO이므로 캐쉬에 보관됨..
		[self.spriteHolder removeChild:sprite cleanup:NO];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Delegate Methods /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// 다음 레벨로 이동하는 기능 
- (void) nextLevel
{
	levelStarted = NO;
	
	// 그 레벨에서 miss가 하나도 없으면 PERFECT_MESSAGE를 message 노드가 뿌려준다
	if(!dataManager.missed) [message showMessage:PERFECT_MESSAGE];
	
	// 현재 레벨이 마지막 레벨이면 showEndGame 메소드를 호출하여 게임이 종료되었음을 알린다.
	if(dataManager.currentlevel == [dataManager.levels count]-1)
	{
		[self showEndGame];
		return;
	}
	
	// GameLayer 오브젝트의 델리게이트 객체가 nextLevel이라는 메소드를 가지고 있으면
	// nextLevel 메소드를 호출
	if ([self.delegate respondsToSelector:@selector(nextLevel)]) 
	{
		// GameLayer의 delegate가 nextLevel 메소드를 처리함
		// GameLayer의 delegate는 GameScene임 - GameScene.m의 init, nextLevel 참조하기.
		[self.delegate nextLevel];
	}
}

// 게임 종료기능
- (void) endGame
{
	[self removeChild:endMenu cleanup:NO];

	// GameLayer 오브젝트의 델리게이트 객체가 endGame이라는 메소드를 가지고 있으면
	// endGame 메소드를 호출 
	if ([self.delegate respondsToSelector:@selector(endGame)]) 
	{
		// GameScene.m의 init, endGame 참조하기
		[self.delegate endGame];
	}
}

- (void) restartGame:(id) sender
{
	[self endGame];

	// GameLayer 오브젝트의 델리게이트 객체가 restartGame이라는 메소드를 가지고 있으면
	// restartGame 메소드를 호출 
	if ([self.delegate respondsToSelector:@selector(restartGame)]) 
	{		
		[self.delegate restartGame];
	}
}

// Noti 센터에 moreGames 노티피케이션을 날려준다.
- (void) moreGames:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"moreGames" object:@""];
}

// Noti 센터에 highScores 노티피케이션을 날려준다.
- (void) highScores:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"highScores" object:@""];
}
///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Callback Methods /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// 버블을 화면에 출력
- (void) showBubbles
{
	levelStarted = YES;
	
	int i;
	
	for(i = 0; i < [orbArray count]; i++)
	{
		// orbArray에 있는 OrbSprite를 하나하나 꺼내어 화면에 출력하는 showBubble 메소드를 호출
		OrbSprite *sprite = (OrbSprite *)[orbArray objectAtIndex:i];
		
		if(!sprite.isHidden)
		{
			[sprite showBubble];
		}
	}
}

- (void) gameOver:(id) sender
{
	[self endGame];
}

- (void) submitScore:(id) sender
{
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"newHighScore" object:@""];
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Public Methods //////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (void) loadLevel:(NSArray *) level
{	
	int i;
	
	[self hideOrbs];
	
	for(i = 0; i < [level count]; i++)
	{
		OrbSprite *sprite;
		
		if([orbArray count] > i)
			sprite = (OrbSprite *) [orbArray objectAtIndex:i];
		else
		{
			sprite = [[OrbSprite alloc] init];
			[orbArray addObject:sprite];
		}
		
		NSString *obj = [level objectAtIndex:i];
		
		[sprite setLabelStr:obj];
		sprite.order = i;
	}
	
	[self arrangeOrbs:[level count]];
	
	float delayTime = 1.5;
	
	if(dataManager.currentlevel > 10) delayTime = 2.5;
	
	[self runAction:[Sequence actions:[DelayTime actionWithDuration:delayTime], 
					 [CallFunc actionWithTarget:self selector:@selector(showBubbles)],
					 nil]];
}

- (void) setScore:(int) score
{
	[scoreLabel setString:[NSString stringWithFormat:@"ABCDE%d", score]];
}

- (void) setMisses:(int) miss
{
	NSString *str = [NSString stringWithFormat:@"MNOPQ%d", miss];
	[missesLabel setString:str];
	
	missesLabel.position = cpv(315 - (str.length*11), 460);
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Touch Events ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if(levelStarted) [self checkForOrbTap:CGPointMake(point.x, 480 - point.y)];
	
	return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	//UITouch *touch = [touches anyObject];
	//CGPoint point = [touch locationInView: [touch view]];
	
	return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	//UITouch *touch = [touches anyObject];
	//CGPoint point = [touch locationInView: [touch view]];
	
	return YES;
}

@end
