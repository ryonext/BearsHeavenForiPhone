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
        rails.position = ccp(480/2, 320/2);
        [self addChild:rails];
        
        sinatra = [[CCSprite alloc]initWithFile:@"sinatra.png"];
        sinatra.position = ccp(480/4, 320);
        [self addChild:sinatra];
        
        [self schedule:@selector(nextFrame:)];
        self.isTouchEnabled = YES;
	}
    [self setUpStringButton];
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
    CCMenuItem *itemRight = [CCMenuItemFont itemWithString:@"→" target:self selector:@selector(pushStringRightButton:)];
    itemRight.tag = 101;

    CCMenuItem *itemLeft = [CCMenuItemFont itemWithString:@"←" target:self selector:@selector(pushStringLeftButton:)];
    itemRight.tag = 102;
    
    CCMenu *menu = [CCMenu menuWithItems:itemLeft, itemRight, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    CGSize size = [[CCDirector sharedDirector] winSize];
    [menu setPosition:ccp( size.width/2, size.height/2-100)];
    [self addChild:menu];
}

- (void)pushStringLeftButton:(id)sender
{
    CGPoint newPoint = CGPointMake(rails.position.x - 50, rails.position.y);
    id move = [CCJumpTo  actionWithDuration:1 position:newPoint height:50 jumps:2];
    [rails runAction:move];
}


- (void)pushStringRightButton:(id)sender
{
    CGPoint newPoint = CGPointMake(rails.position.x + 50, rails.position.y);
    id move = [CCJumpTo  actionWithDuration:1 position:newPoint height:50 jumps:2];
    [rails runAction:move];
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
