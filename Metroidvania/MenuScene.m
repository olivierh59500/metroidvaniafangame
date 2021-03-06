//
//  MenuScene.m
//  Metriodvania
//
//  Created by nick vancise on 6/20/18.


#import "MenuScene.h"
#import "GameLevelScene.h"
#import "GameLevelScene2.h"

@implementation MenuScene{
    SKSpriteNode *_playlabel;
    SKSpriteNode *_playbutton;
    SKSpriteNode *_cntrllabel;
    SKSpriteNode *_cntrlbkrnd;
    BOOL viewingcntrls;
    SKAction *shipflyact;
    SKSpriteNode *samusgunship;
    SKSpriteNode *shipflames1;
    SKSpriteNode *shipflamesright2;
    SKSpriteNode *shipflamesleft2;
    SKAction *shipreducesize;
    SKAction *flameflicker;
    UIBezierPath *shippath;
    SKAction *shipflyac;
    SKTransition *menutolvl1tran;
}

-(instancetype)initWithSize:(CGSize)size {
    if(self=[super initWithSize:size]){
        
        SKTextureAtlas *backgroundtexatl=[SKTextureAtlas atlasNamed:@"menusceneitems"];
        SKTexture *backgroundtex=[backgroundtexatl textureNamed:@"parallax-space-backgound.png"];
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithTexture:backgroundtex size:self.size];
        background.anchorPoint=CGPointMake(0,0);
        background.position=CGPointMake(0,0);
        background.zPosition=0;
        [self addChild:background];
        
        SKSpriteNode *stars1=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-stars.png"] size:self.size];
        stars1.anchorPoint=CGPointMake(0,0);
        stars1.position=CGPointMake(0,0);
        stars1.zPosition=1;
        [self addChild:stars1];
        
        SKAction *starsactinc=[SKAction fadeAlphaTo:0 duration:5.0];
        SKAction *starsactdec=[SKAction fadeAlphaTo:1 duration:5.0];
        NSArray *starsactarr=@[starsactinc,starsactdec];
        SKAction *starsactseq=[SKAction sequence:starsactarr];
        [stars1 runAction:[SKAction repeatActionForever:starsactseq]];
        
        NSArray *pixstarsarr=@[[backgroundtexatl textureNamed:@"star1.png"],[backgroundtexatl textureNamed:@"star2.png"],[backgroundtexatl textureNamed:@"star3.png"],[backgroundtexatl textureNamed:@"star4.png"],[backgroundtexatl textureNamed:@"star5.png"]];
        SKAction *stariterate=[SKAction animateWithTextures:pixstarsarr timePerFrame:0.2];
        SKSpriteNode *pixelstar=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"stars1.png"]];
        pixelstar.zPosition=2;
        pixelstar.size=CGSizeMake(9,9);
        pixelstar.position=CGPointMake(50,50);
        [self addChild:pixelstar];
        [pixelstar runAction:[SKAction repeatActionForever:stariterate]];
        
        SKSpriteNode *pixelstar2=pixelstar.copy;
        pixelstar2.position=CGPointMake(170,125);
        [self addChild:pixelstar2];
        SKSpriteNode *pixelstar3=pixelstar.copy;
        pixelstar3.position=CGPointMake(500,143);
        [self addChild:pixelstar3];
        SKSpriteNode *pixelstar4=pixelstar.copy;
        pixelstar4.position=CGPointMake(250,300);
        [self addChild:pixelstar4];
        SKSpriteNode *pixelstar5=pixelstar.copy;
        pixelstar5.position=CGPointMake(360,88);
        [self addChild:pixelstar5];
        SKSpriteNode *pixelstar6=pixelstar.copy;
        pixelstar6.position=CGPointMake(76,147);
        [self addChild:pixelstar6];
        SKSpriteNode *pixelstar7=pixelstar.copy;
        pixelstar7.position=CGPointMake(445,258);
        [self addChild:pixelstar7];
        
         __weak MenuScene *weakself=self;
        UIBezierPath*starbez=[UIBezierPath bezierPath];
        [starbez moveToPoint:CGPointMake(-20,self.size.height+5)];
        [starbez addQuadCurveToPoint:CGPointMake(self.size.width-60,-180) controlPoint:CGPointMake(self.size.width/2+90,self.size.height-20)];
        SKEmitterNode*shootingstar=[SKEmitterNode nodeWithFileNamed:@"shootingstar.sks"];
        shootingstar.particleRenderOrder=SKParticleRenderOrderDontCare;
        shootingstar.targetNode=self;
        SKAction*shootstarblk=[SKAction runBlock:^{
            [shootingstar resetSimulation];
            [weakself addChild:shootingstar];
            [shootingstar runAction:[SKAction followPath:starbez.CGPath asOffset:NO orientToPath:NO duration:1.8] completion:^{[shootingstar resetSimulation];[shootingstar removeFromParent];}];
        }];
        SKAction*shootingstarac=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:2],shootstarblk,[SKAction waitForDuration:8.0], nil]]];
        [self runAction:shootingstarac];
        
        
        SKSpriteNode *bigplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-big-planet.png"] size:CGSizeMake(100,99)];
        bigplanet.position=CGPointMake(self.size.width/2+60,self.size.height/2+30);
        bigplanet.zPosition=2;
        [self addChild:bigplanet];
        
        SKSpriteNode *ringplanet=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-ring-planet.png"] size:CGSizeMake(51,115)];
        ringplanet.position=CGPointMake(self.size.width/4,self.size.height/2-48);
        ringplanet.zPosition=2;
        [self addChild:ringplanet];
        
        SKSpriteNode *farplanets=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"parallax-space-far-planets.png"] size:CGSizeMake(272,160)];
        farplanets.position=CGPointMake(self.size.width/2+80,self.size.height/2+10);
        farplanets.zPosition=3;
        [self addChild:farplanets];
        
        SKSpriteNode *titlelabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"titlelabelv2.png"] size:CGSizeMake(453,24)];
        titlelabel.position=CGPointMake(self.size.width/2,self.size.height/2+25);
        titlelabel.zPosition=4;
        [self addChild:titlelabel];
        
        
        SKSpriteNode *referencepoint=[[SKSpriteNode alloc] init];
        referencepoint.position=bigplanet.position;
        SKSpriteNode *alienship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        alienship.size=CGSizeMake(28,17);
        alienship.position=CGPointMake(45,50);
        SKAction *thrustrepeat=[SKAction repeatAction:[SKAction animateWithTextures:[NSArray arrayWithObjects:[backgroundtexatl textureNamed:@"shipv2_2.png"],[backgroundtexatl textureNamed:@"shipv2_3.png"], nil] timePerFrame:0.03] count:38];
        SKAction *waitthrustersact=[SKAction waitForDuration:11.0];
        SKAction *beginningtex=[SKAction setTexture:[backgroundtexatl textureNamed:@"shipv2.png"]];
        SKAction *thrustact=[SKAction sequence:[NSArray arrayWithObjects:thrustrepeat,beginningtex,waitthrustersact,nil]];
        alienship.zPosition=2;
        alienship.zRotation=-0.77;
        [self addChild:referencepoint];
        [referencepoint addChild:alienship];
        [referencepoint runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI duration:260]]];
        [alienship runAction:[SKAction repeatActionForever:thrustact]];
        
        
        _playlabel=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"playlabel.png"] size:CGSizeMake(120,30)];
        _playlabel.position=CGPointMake(self.size.width/2+110,self.size.height/2-110);
        _playlabel.zPosition=4;
        [self addChild:_playlabel];
        
        _playbutton=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"buttonplay.png"] size:CGSizeMake(64,64)];
        _playbutton.position=CGPointMake(self.size.width/2+200,self.size.height/2-110);
        _playbutton.zPosition=4;
        [self addChild:_playbutton];
        
        _cntrllabel=[SKSpriteNode spriteNodeWithImageNamed:@"controllabel.png"];
        _cntrllabel.position=CGPointMake(self.size.width/2-130,self.size.height/2-110);
        [self addChild:_cntrllabel];
        
        _cntrlbkrnd=[SKSpriteNode spriteNodeWithColor:[UIColor darkGrayColor] size:CGSizeMake(self.size.width-185,95)];
        _cntrlbkrnd.alpha=0;
        _cntrlbkrnd.position=CGPointMake(self.size.width/2,self.size.height/2);
        _cntrlbkrnd.zPosition=5;
        [self addChild:_cntrlbkrnd];
        
        SKLabelNode *cntrll1=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        SKLabelNode *cntrll2=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        SKLabelNode *cntrll3=[SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        cntrll1.zPosition=6;
        cntrll1.fontSize=16;
        cntrll1.text=@"Use the Dpad to move around,";
        cntrll1.position=CGPointMake(0,20);
        cntrll2.zPosition=6;
        cntrll2.fontSize=16;
        cntrll2.text=@"Tap the upper right half of the screen to melee,";
        cntrll2.position=CGPointMake(0,-5);
        cntrll3.zPosition=6;
        cntrll3.fontSize=16;
        cntrll3.text=@"Tap the lower right half of the screen to fire your weapon";
        cntrll3.position=CGPointMake(0,-30);
        
        [_cntrlbkrnd addChild:cntrll1];
        [_cntrlbkrnd addChild:cntrll2];
        [_cntrlbkrnd addChild:cntrll3];
        
        //ship fly to planet
        samusgunship=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"samusgunship.png"]];
        shipflames1=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflames1.png"]];
        shipflamesright2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesright2.png"]];
        shipflamesleft2=[SKSpriteNode spriteNodeWithTexture:[backgroundtexatl textureNamed:@"gunshipflamesleft2.png"]];
        
        
        shipreducesize=[SKAction scaleTo:0 duration:1.8];
        flameflicker=[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction fadeAlphaTo:0 duration:0.08],[SKAction fadeAlphaTo:1 duration:0.08], nil]]];
        
        shippath=[UIBezierPath bezierPath];
        [shippath moveToPoint:samusgunship.position];
        [shippath addQuadCurveToPoint:CGPointMake(self.size.width/2+23, self.size.height/2+75) controlPoint:CGPointMake(self.size.width/2-190, self.size.height/2+90)];
        
        
        samusgunship.position=CGPointMake(-15,-15);
        shipflamesright2.position=CGPointMake(25,-8);
        shipflamesleft2.position=CGPointMake(-25,-8);
        [samusgunship addChild:shipflames1];
        [samusgunship addChild:shipflamesright2];
        [samusgunship addChild:shipflamesleft2];
        [self addChild:samusgunship];
        
        menutolvl1tran=[SKTransition fadeWithDuration:1.5];
        menutolvl1tran.pausesOutgoingScene=NO;
        
        shipflyac=[SKAction group:@[shipreducesize,[SKAction followPath:shippath.CGPath duration:1.7]]];
        [shipflyac setTimingMode:SKActionTimingEaseIn];
       
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch*touch in touches){
        if((CGRectContainsPoint(_playlabel.frame,[touch locationInNode:self])) || (CGRectContainsPoint(_playbutton.frame,[touch locationInNode:self]))){
            self.userInteractionEnabled=NO;
            
            __weak MenuScene *weakself = self;
            __weak SKTransition*weakmenutolvl1tran=menutolvl1tran;
            __weak SKSpriteNode*weakshipflamesright2=shipflamesright2;
            __weak SKSpriteNode*weakshipflamesleft2=shipflamesleft2;
            __weak SKAction *weakflameflicker=flameflicker;
            __weak SKSpriteNode *weaksamusgunship=samusgunship;
            __weak SKAction *weakshipflyac=shipflyac;
            CGSize nextSceneSize=CGSizeMake(self.view.bounds.size.width/1.2,self.view.bounds.size.height/1.2-10);
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background thread, preloading the scene here
                GameLevelScene*preload=[[GameLevelScene alloc]initWithSize:nextSceneSize];
                preload.scaleMode = SKSceneScaleModeAspectFill;
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    NSLog(@"preloaded lvl2");
                    [weakshipflamesright2 runAction:weakflameflicker];
                    [weakshipflamesleft2 runAction:weakflameflicker];
                    [weaksamusgunship runAction:weakshipflyac completion:^{ [weakself.view presentScene:preload transition:weakmenutolvl1tran];}];
                });
            });
            
            
        }
        else if(CGRectContainsPoint(_cntrllabel.frame,[touch locationInNode:self]) && !viewingcntrls){
            [_cntrlbkrnd runAction:[SKAction fadeInWithDuration:0.2]];
            viewingcntrls=YES;
        }
        else if(viewingcntrls){
            [_cntrlbkrnd runAction:[SKAction fadeOutWithDuration:0.2]];
            viewingcntrls=NO;
        }
    }
}

/*- (void)dealloc {
 NSLog(@"MENU SCENE DEALLOCATED");
 }*/

@end
