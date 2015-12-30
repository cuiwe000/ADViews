//
//  ADVerifyButton.m
//  GoldenRoad
//
//  Created by msl on 15/10/14.
//  Copyright © 2015年 Haodi. All rights reserved.
//

#import "ADVerifyButton.h"
#import "NSTimer+Addition.h"

@interface ADVerifyButton (){
    NSTimer *btnTimer;
    NSInteger timeDuration;
}

@end

@implementation ADVerifyButton


-(void)dealloc{
    [btnTimer invalidate];
    btnTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _duration = 60;
        timeDuration = _duration;
        [self configButton];
    }
    return self;
}

- (void)configButton{
    __weak typeof(self)weakSelf = self;
    btnTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timeChange) userInfo:nil repeats:YES];
    [btnTimer pauseTimer];
    
    [self addTarget:self action:@selector(verifyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setBackgroundColor:[ADViewStyleGuide backgroundColor]];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [ADViewStyleGuide seperateColor].CGColor;

}

- (void)startDurationTime{
    [btnTimer resumeTimer];
    [self setEnabled:NO];
}

-(void)stopDurationTime{
    timeDuration = _duration;
    [self pauseDurationTime];
}

- (void)pauseDurationTime{
    [btnTimer pauseTimer];
    [self setEnabled:YES];
    [self setTitle:@"重新发送" forState:UIControlStateNormal];
}

- (void)timeChange{
    timeDuration--;
    [self setTitle:[@(timeDuration) stringValue] forState:UIControlStateNormal];
    
    if (timeDuration <= 0) {
        [self stopDurationTime];
    }
}

-(void)verifyAction{
    [self startDurationTime];
}

@end
