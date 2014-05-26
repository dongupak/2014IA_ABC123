/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "GameScene.h"

@interface GameScene (Private)

- (void) endGame;

@end

#define frameRate 0.1

@implementation GameScene

@synthesize mainLayer;
@synthesize menuLayer;
@synthesize dataManager;

- (void) dealloc
{
	[self unschedule:@selector(tick:)];
	[menuLayer release];
	[mainLayer release];
	[dataManager release];
	[super dealloc];
}

// GameScene의 초기화에서 행하는 동작들.
- (id) init
{
	// 정상적으로 메모리를 할당 받은 경우에...
	self = [super init];
	
	// 점수와 레벨 관리를 위한 DataManager 객체의 생성과 초기화 기능을 수행
	if (self)
	{
		dataManager = [DataManager sharedManager];
		dataManager.currentlevel = 0;
		dataManager.score = 0;
		dataManager.misses = 1;
		
		// 게임 레이어가 메인 레이어가 됨
		GameLayer *layer = [[GameLayer alloc] init];
		self.mainLayer = layer;
		[layer release];  // 증가한 retain값을 하나 감소 시킴..
		mainLayer.delegate = self;
		
		[self addChild:mainLayer];
		// frameRate는 여기서 상수 0.1로 선언되어 있다.
		[self schedule: @selector(tick:) interval:frameRate];
		[self endGame];
	}
	
	return self;
}

// frameRate 시간에 의하여 주기적으로 호출되는 함수
// 매 프레임마다 tick이 호출됨 
-(void)tick: (ccTime) dt
{	
	// score값과 miss값을 메인 레이어에서 보여주는 역할.
	if(dataManager.score > -1) 
		[mainLayer setScore:dataManager.score];
	
	[mainLayer setMisses:dataManager.misses];
}

// 다음 레벨로 이동시..
-(void)nextLevel
{
	NSLog(@"in GameScene : nextLevel");
	// miss가 없으면 score에 5를 더해줌
	if(!dataManager.missed) dataManager.score += 5;
	
	//  데이터 매니저의 레벨을 이동, 인덱스 초기화, miss 값등을 초기화 함.
	dataManager.currentlevel += 1;
	dataManager.currentindex = 0;
	dataManager.misses += 1;
	dataManager.missed = NO;
	
	// 마지막 level이 아닌 경우에는 mainLayer에 다음 레벨을 추가함 
	if(dataManager.currentlevel < [[dataManager levels] count])
		[mainLayer loadLevel:[[dataManager levels] 
							  objectAtIndex:dataManager.currentlevel]];
}
		
// 게임 종료시하는 일
- (void) endGame
{
	// 게임이 종료될 적에는 메뉴 레이어를 addChild로 자식 노드에 추가 
	if(menuLayer == nil)
	{
		MenuLayer *menu = [[MenuLayer alloc] init];
		self.menuLayer = menu;
		[menu release];
		
		menuLayer.delegate = self;
	}
	
	[self addChild:menuLayer];
}

// 게임 재시작.
- (void) restartGame
{
	// 메뉴 레이어의 하위에 있는 노드를 삭제시키고
	if(menuLayer != nil) 
		[self removeChild:menuLayer cleanup:NO];
	
	// 데이터 매니저 내부의 모든 값들 역시 초기화시킨다.
	dataManager.currentlevel = 0;
	dataManager.currentindex = 0;
	dataManager.misses = 1;
	dataManager.score = 0;
	dataManager.missed = NO;
	
	// 메인 레이어에 currentlevel값으로 레벨을 로드한다.
	[mainLayer loadLevel:[[dataManager levels] 
						  objectAtIndex:dataManager.currentlevel]];
}

@end
