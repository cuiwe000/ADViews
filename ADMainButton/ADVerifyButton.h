//
//  ADVerifyButton.h
//  GoldenRoad
//
//  Created by msl on 15/10/14.
//  Copyright © 2015年 Haodi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADVerifyButton : UIButton

/**
 *  默认 60秒
 */
@property (nonatomic) NSInteger duration;


-(void)startDurationTime;

-(void)stopDurationTime;


@end
