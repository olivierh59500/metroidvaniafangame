//
//  arachnusboss.m
//  Metroidvania
//
//  Created by nick vancise on 7/23/18.


#import "arachnusboss.h"
#import "SKTUtils.h"

@implementation arachnusboss{
    SKAction *moveforeward;
    SKAction *movebackward;
    SKAction *fireattackleft;
    SKAction *fireattackright;
    SKAction *morphballattackright;
    SKAction *morphballattackleft;
    SKAction *slashattackleft;
    SKAction *slashattackright;
    SKAction *turn;
    SKAction *recievedamageright;
    SKAction *recievedamageleft;
    
    SKAction *addfiretoparentmap;
    SKSpriteNode *firesprite;
    CGPoint prevcoorddist;
}

-(instancetype)initWithImageNamed:(NSString *)name{
    __weak NSString *weakname=name;
    if(self == [super initWithImageNamed:weakname]){
        self.health=150;
        self.active=NO;
        
        SKTextureAtlas *arachnustextures=[SKTextureAtlas atlasNamed:@"Arachnus"];
        __weak arachnusboss*weakself=self;
        
        //position constraints
        SKConstraint*xconst=[SKConstraint positionX:[SKRange rangeWithLowerLimit:3488 upperLimit:4208]];
        xconst.referenceNode=self.parent;
        self.constraints=[NSArray arrayWithObjects:xconst, nil];
        
        //morphball animations
        NSArray *morphtoballrighttex=@[[arachnustextures textureNamed:@"toball_1.png"],[arachnustextures textureNamed:@"toball_2.png"],[arachnustextures textureNamed:@"toball_3.png"],[arachnustextures textureNamed:@"toball_4.png"]];
        SKAction *morphtoballrightanim=[SKAction animateWithTextures:morphtoballrighttex timePerFrame:0.1 resize:YES restore:YES];
        
        NSArray *ballrighttex=@[[arachnustextures textureNamed:@"ball_1.png"],[arachnustextures textureNamed:@"ball_2.png"],[arachnustextures textureNamed:@"ball_3.png"],[arachnustextures textureNamed:@"ball_4.png"]];
        SKAction *ballattackrightanim=[SKAction animateWithTextures:ballrighttex timePerFrame:0.04 resize:YES restore:YES];
        
        SKSpriteNode *dustball=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Dust1.png"]];
        SKAction *dustac=[SKAction repeatAction:[SKAction animateWithTextures:[NSArray arrayWithObjects:[arachnustextures textureNamed:@"Dust1.png"],[arachnustextures textureNamed:@"Dust2.png"],[arachnustextures textureNamed:@"Dust3.png"],[arachnustextures textureNamed:@"Dust4.png"], nil] timePerFrame:0.1 resize:NO restore:YES] count:6];
        dustball.position=CGPointMake(-10,-11);
        dustball.alpha=0.85;
        SKAction *dustaction=[SKAction runBlock:^{[weakself addChild:dustball];[dustball runAction:dustac completion:^{[dustball removeFromParent];}];}];
      
        morphballattackright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:1 duration:0],morphtoballrightanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:ballattackrightanim count:15],dustaction,[SKAction moveByX:350 y:0 duration:2.4], nil]],[SKAction moveByX:0 y:8 duration:0],[morphtoballrightanim reversedAction], nil]];
        morphballattackleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:-1 duration:0],morphtoballrightanim,[SKAction moveByX:0 y:-8 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:ballattackrightanim count:15],dustaction,[SKAction moveByX:-350 y:0 duration:2.4], nil]],[SKAction moveByX:0 y:8 duration:0],[morphtoballrightanim reversedAction], nil]];
        
        //move f/b animations
        NSArray *moveforewardtex=@[[arachnustextures textureNamed:@"walk_1.png"],[arachnustextures textureNamed:@"walk_2.png"],[arachnustextures textureNamed:@"walk_3.png"],[arachnustextures textureNamed:@"walk_4.png"],[arachnustextures textureNamed:@"walk_5.png"],[arachnustextures textureNamed:@"walk_6.png"],[arachnustextures textureNamed:@"walk_7.png"],[arachnustextures textureNamed:@"walk_8.png"],[arachnustextures textureNamed:@"walk_9.png"],[arachnustextures textureNamed:@"walk_10.png"],[arachnustextures textureNamed:@"walk_11.png"],[arachnustextures textureNamed:@"walk_12.png"]];
        SKAction *moveforewardanim=[SKAction animateWithTextures:moveforewardtex timePerFrame:0.08 resize:YES restore:YES];
        
        moveforeward=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:1 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:moveforewardanim count:3],[SKAction moveByX:150 y:0 duration:2.88], nil]], nil]];
        movebackward=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:-1 duration:0],[SKAction group:[NSArray arrayWithObjects:[SKAction repeatAction:moveforewardanim count:3],[SKAction moveByX:-150 y:0 duration:2.88], nil]], nil]];
        
        //fireattack animations
        NSArray *fireattackrighttex=@[[arachnustextures textureNamed:@"spitfire_1.png"],[arachnustextures textureNamed:@"spitfire_2.png"],[arachnustextures textureNamed:@"spitfire_3.png"],[arachnustextures textureNamed:@"spitfire_4.png"],[arachnustextures textureNamed:@"spitfire_5.png"]];
        SKAction *fireattackrightanim=[SKAction animateWithTextures:fireattackrighttex timePerFrame:0.14 resize:YES restore:YES];
        
        NSArray *fireburntex=@[[arachnustextures textureNamed:@"Fire1.png"],[arachnustextures textureNamed:@"Fire2.png"]];
        NSArray *fireendtex=@[[arachnustextures textureNamed:@"Fire3.png"],[arachnustextures textureNamed:@"Fire4.png"]];
        
        SKAction *fireburnanim=[SKAction animateWithTextures:fireburntex timePerFrame:0.1 resize:NO restore:YES];
        firesprite=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
        firesprite.position=CGPointMake(16,2);
        SKAction *fireendanim=[SKAction animateWithTextures:fireendtex timePerFrame:0.1 resize:NO restore:NO];
        
        SKAction *addfiretoparentblk=[SKAction runBlock:^{
            __block CGPoint pointinlevel=[weakself convertPoint:CGPointMake(49,-24) toNode:weakself.parent];
            SKAction *blkac=[SKAction runBlock:^{
                SKSpriteNode*firecpy=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
                firecpy.position=pointinlevel;
                [firecpy runAction:[SKAction repeatActionForever:fireburnanim]];
                pointinlevel=CGPointAdd(pointinlevel,CGPointMake(13,0));
                [weakself.parent addChild:firecpy];
                [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[firecpy removeAllActions];}], nil]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.07],blkac, nil]] count:10]];
        }];
        
        UIBezierPath *firepath=[UIBezierPath bezierPath];
        [firepath moveToPoint:CGPointZero];
        [firepath addQuadCurveToPoint:CGPointMake(37,-26) controlPoint:CGPointMake(40,0)];
        __weak SKSpriteNode*weakfiresprite=firesprite;
        SKAction *fireblk=[SKAction runBlock:^{[weakself addChild:weakfiresprite];[weakfiresprite runAction:[SKAction repeatActionForever:fireburnanim]];[weakfiresprite runAction:[SKAction followPath:firepath.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfiresprite removeFromParent];weakfiresprite.position=CGPointMake(16,2);[weakfiresprite removeAllActions];}];}];
        SKAction *firespriteac=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.52],fireblk, nil]];
       
        fireattackright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction scaleXTo:1 duration:0],[SKAction moveByX:0 y:3 duration:0],fireattackrightanim,firespriteac, nil]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15],nil]];
        
        //below is redifinition of addfiretoparentblk,fireblk,firespriteac so as to flip for left fireattack
        addfiretoparentblk=[SKAction runBlock:^{
            __block CGPoint pointinlevel=[weakself convertPoint:CGPointMake(49,-24) toNode:weakself.parent];
            SKAction *blkac=[SKAction runBlock:^{
                SKSpriteNode*firecpy=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"Fire1.png"]];
                firecpy.position=pointinlevel;
                [firecpy runAction:[SKAction repeatActionForever:fireburnanim]];
                pointinlevel=CGPointSubtract(pointinlevel,CGPointMake(13,0));
                [weakself.parent addChild:firecpy];
                [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:4.0],fireendanim,[SKAction runBlock:^{[firecpy removeFromParent];[firecpy removeAllActions];}], nil]]];
            }];
            [weakself runAction:[SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.07],blkac, nil]] count:10]];
        }];
        fireblk=[SKAction runBlock:^{[weakself addChild:weakfiresprite];[weakfiresprite runAction:[SKAction repeatActionForever:fireburnanim]];[weakfiresprite runAction:[SKAction followPath:firepath.CGPath duration:0.4] completion:^{[weakself runAction:addfiretoparentblk];[weakfiresprite removeFromParent];weakfiresprite.position=CGPointMake(16,2);[weakfiresprite removeAllActions];}];}];
        firespriteac=[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:0.52],fireblk, nil]];
        
        fireattackleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction group:[NSArray arrayWithObjects:[SKAction scaleXTo:-1 duration:0],[SKAction moveByX:0 y:3 duration:0],fireattackrightanim,firespriteac, nil]],[SKAction moveByX:0 y:-3 duration:0],[SKAction waitForDuration:0.15],nil]];
        
        
        //slash animations
        NSArray *slashrightex=@[[arachnustextures textureNamed:@"slash_1.png"],[arachnustextures textureNamed:@"slash_2.png"],[arachnustextures textureNamed:@"slash_3.png"],[arachnustextures textureNamed:@"slash_4.png"],[arachnustextures textureNamed:@"slash_5.png"],[arachnustextures textureNamed:@"slash_6.png"],[arachnustextures textureNamed:@"slash_7.png"],[arachnustextures textureNamed:@"slash_8.png"],[arachnustextures textureNamed:@"slash_9.png"],[arachnustextures textureNamed:@"slash_10.png"],[arachnustextures textureNamed:@"slash_11.png"],[arachnustextures textureNamed:@"slash_12.png"],[arachnustextures textureNamed:@"slash_13.png"],[arachnustextures textureNamed:@"slash_14.png"],[arachnustextures textureNamed:@"slash_15.png"]];
        SKAction *slashrightanim=[SKAction animateWithTextures:slashrightex timePerFrame:0.09 resize:YES restore:YES];
        
        //initialize slash projectiles
        self.slashprojectile=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"arachnus_slashsingle.png"]];
        self.slashprojectile.position=CGPointMake(27,0);
        SKSpriteNode *slashprojectiletrail=[SKSpriteNode spriteNodeWithTexture:[arachnustextures textureNamed:@"arachnus_slashsingle.png"]];
        slashprojectiletrail.position=CGPointMake(-25,0);
        slashprojectiletrail.alpha=0.6;
        [self.slashprojectile addChild:slashprojectiletrail];
        NSArray*projtextures=@[[arachnustextures textureNamed:@"arachnus_slash_1.png"],[arachnustextures textureNamed:@"arachnus_slash_2.png"],[arachnustextures textureNamed:@"arachnus_slash_3.png"],[arachnustextures textureNamed:@"arachnus_slash_4.png"]];
        SKAction *slashprojmove=[SKAction moveBy:CGVectorMake(430,0) duration:1.8];
        
        slashattackright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:1 duration:0],[SKAction group:[NSArray arrayWithObjects:slashrightanim,[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            slashcpy.position=pointinlevel;
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                slashcpy.position=CGPointMake(27,0);}];}], nil]],nil]], nil]];
        
        slashprojmove=[SKAction moveBy:CGVectorMake(-430,0) duration:1.8];
        
        slashattackleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:-1 duration:0],[SKAction group:[NSArray arrayWithObjects:slashrightanim,[SKAction sequence:[NSArray arrayWithObjects:[SKAction waitForDuration:1.17],[SKAction runBlock:^{CGPoint pointinlevel=[weakself convertPoint:CGPointMake(27,0) toNode:weakself.parent];
            SKSpriteNode*slashcpy=weakself.slashprojectile.copy;
            [slashcpy setXScale:-1];
            slashcpy.position=pointinlevel;
            [weakself.parent addChild:slashcpy];
            [slashcpy runAction:slashprojmove completion:^{[slashcpy removeFromParent];
                slashcpy.position=CGPointMake(27,0);}];}], nil]],nil]], nil]];
        
        //turn animations
        NSArray *turnrighttex=@[[arachnustextures textureNamed:@"turn_4.png"],[arachnustextures textureNamed:@"turn_3.png"],[arachnustextures textureNamed:@"turn_2.png"],[arachnustextures textureNamed:@"turn_1.png"]];
        turn=[SKAction animateWithTextures:turnrighttex timePerFrame:0.12 resize:YES restore:YES];
        
        //recieve damage animations
        NSArray *recievedamagetex=@[[arachnustextures textureNamed:@"damage_scream_1.png"],[arachnustextures textureNamed:@"damage_scream_2.png"],[arachnustextures textureNamed:@"damage_scream_3.png"],[arachnustextures textureNamed:@"damage_scream_4.png"],[arachnustextures textureNamed:@"damage_scream_5.png"]];
        SKAction *recievedamagerightanim=[SKAction animateWithTextures:recievedamagetex timePerFrame:0.14 resize:YES restore:YES];
        
        //rect for random fire points to be inside (dmg)
        CGRect firerect=CGRectInset(self.frame, 6, 2);
        SKAction *adddmgfire=[SKAction runBlock:^{
            CGPoint p=firerect.origin;
            p.x += arc4random_uniform((u_int32_t) CGRectGetWidth(firerect));
            p.y += arc4random_uniform((u_int32_t) CGRectGetHeight(firerect));
            SKSpriteNode *firecpy=weakfiresprite.copy;
            [firecpy removeAllActions];
            firecpy.position=p;
            [firecpy runAction:[SKAction sequence:[NSArray arrayWithObjects:fireburnanim,fireendanim, nil]] completion:^{[firecpy removeFromParent];}];
            [weakself addChild:firecpy];
        }];
        
        recievedamageright=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:1 duration:0],[SKAction moveByX:0 y:5 duration:0],[SKAction group:[NSArray arrayWithObjects:recievedamagerightanim,[SKAction repeatAction:adddmgfire count:3], nil]],[SKAction moveByX:0 y:-5 duration:0], nil]];
        recievedamageleft=[SKAction sequence:[NSArray arrayWithObjects:[SKAction scaleXTo:-1 duration:0],[SKAction moveByX:0 y:5 duration:0],[SKAction group:[NSArray arrayWithObjects:recievedamagerightanim,[SKAction repeatAction:adddmgfire count:3], nil]],[SKAction moveByX:0 y:-5 duration:0], nil]];
        
        self.testallactions=[SKAction sequence:[NSArray arrayWithObjects:morphballattackright,turn,morphballattackleft,movebackward,turn,moveforeward,fireattackright,turn,fireattackleft,turn,recievedamageright,turn,recievedamageleft,slashattackleft,turn,slashattackright, nil]];
        
        
    }
    
    return self;
}


-(void)handleanimswithfocuspos:(CGPoint)focuspos{
    
    if(![self hasActions]){//potential approach to handling one action at a time
       
        SKAction *actoexecute;
        CGPoint coorddist=CGPointSubtract(focuspos, self.position);
        
        NSLog(@"coorddist:%@",NSStringFromCGPoint(coorddist));
        
        if((coorddist.x<0 && prevcoorddist.x>0) || (coorddist.x>0 && prevcoorddist.x<0))
            actoexecute=turn;
        else if(coorddist.x<-200)
            actoexecute=morphballattackleft;
        else if(coorddist.x<-150)
            actoexecute=slashattackleft;
        else if(coorddist.x<-100)
            actoexecute=fireattackleft;
        else if(coorddist.x<0)
            actoexecute=movebackward;
        else if(coorddist.x>200)
            actoexecute=morphballattackright;
        else if(coorddist.x>150)
            actoexecute=slashattackright;
        else if(coorddist.x>100)
            actoexecute=fireattackright;
        else if(coorddist.x<100)
            actoexecute=moveforeward;
        
      
        prevcoorddist=coorddist;
        if(actoexecute==turn)
        [self runAction:actoexecute];
        else
        [self runAction:[SKAction sequence:[NSArray arrayWithObjects:actoexecute,[SKAction waitForDuration:0.5], nil]]];
        
    }

}



- (void)dealloc {
 NSLog(@"ARACHNUS DEALLOCATED");
 }


@end
