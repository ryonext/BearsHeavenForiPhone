//
//  HelloWorldLayer.m
//  TestGame
//
//  Created by ryonext on 2013/06/03.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SneakyJoystickSkinnedBase.h"
#import "SneakyJoystick.h"
#import "ColoredCircleSprite.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        rails = [[CCSprite alloc]initWithFile:@"rails.png"];
        rails.position = ccp(480/2, 320/3 * 2);
        [self addChild:rails];
        
        sinatra = [[CCSprite alloc]initWithFile:@"sinatra.png"];
        sinatra.position = ccp(480/4, 320);
        [self addChild:sinatra];
        
        [self schedule:@selector(nextFrame:)];
//        self.isTouchEnabled = YES;
	}
    [self setUpStringButton];
    
    
    SneakyJoystickSkinnedBase *skinjoystick = [[SneakyJoystickSkinnedBase alloc] init];
    skinjoystick.position = ccp(50, 100);
    
    skinjoystick.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:48];;//スプライトを指定
    skinjoystick.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:16];;//スプライトを指定
    skinjoystick.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,70,70)];
    
    SneakyJoystick *joystick = skinjoystick.joystick;
    joystick.autoCenter = YES; //自動的に真ん中に戻すかどうか
    joystick.hasDeadzone = YES;//ジョイスティックの反応しないエリアを作るかどうか
    joystick.deadRadius = 10;//反応しないエリアの半径を指定
    [self addChild:skinjoystick z:0 tag:30];
    
    
    
    SneakyButtonSkinnedBase *skinAttackButton = [[SneakyButtonSkinnedBase alloc] init];
    skinAttackButton.position = ccp(250,100);
    skinAttackButton.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:32];//基本のスプライト
    skinAttackButton.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:32];//ボタンを押している時のスプライト
    skinAttackButton.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:32];//ボタンを離した時のスプライト
    skinAttackButton.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
    [self addChild:skinAttackButton z:0 tag:31];
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[rails release];
    [sinatra release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) nextFrame:(ccTime)dt {
//    rails.position = ccp(rails.position.x + 100*dt, rails.position.y);
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    if (rails.position.x > winSize.width/* + rails.contentSize.width / 2*/) {
        CGPoint p = rails.position;

        p.x = 0 - rails.contentSize.width / 2;
        rails.position = p;
    }
    else if(rails.position.x < 0 - rails.contentSize.width / 2){
        CGPoint p = rails.position;
        
        p.x = winSize.width;
        rails.position = p;
    }
    
    SneakyJoystickSkinnedBase *joy = (SneakyJoystickSkinnedBase *)[self getChildByTag:30];
    CGPoint scaledVelocity = ccpMult(joy.joystick.velocity,  10);
    rails.position = ccp(rails.position.x + (20 * scaledVelocity.x) * dt, rails.position.y );

    SneakyButtonSkinnedBase *button = (SneakyButtonSkinnedBase *)[self getChildByTag:31];
    NSLog(@"%d", button.button.active);
    if (button.button.active) {
        [self jump:scaledVelocity.x];
    }
}

-(void) registerWithTouchDispatcher{
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    //    id scene = [HelloWorldLayer scene];
    //    id transition = [CCTransitionFade transitionWithDuration:1.0f scene:scene];
    //    [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)setUpStringButton
{
}

- (void)jump:(float) velocity{
    [rails runAction:[CCJumpTo actionWithDuration:1 position:ccp(rails.position.x + (20 * velocity), rails.position.y) height:50 jumps:1]];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
