//
//  HYScratchCardView.h
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const ScratchNotification = @"ScratchNotification";

typedef void(^scratchCompletion)(id userInfo);
typedef void(^scratchCanSeeCompletion)(id sender);

@interface HYScratchCardView : UIView

/**
 要刮的底图.
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  底图 要显示的文字 haodi
 */
@property (nonatomic, strong) NSString *descripeText;

/**
 涂层图片.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

/**
 涂层是否已被刮开
 */
@property (nonatomic, assign, readonly, getter = isOpen) BOOL open;

/**
 * 要刮的底图 是否 被能看到 默认挂到 30% 后 可见 canSee = YES
 */
@property (nonatomic, assign)BOOL canSee;

@property (nonatomic, copy)scratchCanSeeCompletion canSeeCompletion;

/**
 刮出后的回调.
 */
@property (nonatomic, strong) scratchCompletion completion;

/**
 可携带一些自定义信息, 将会在回调的block内回传.
 */
@property (nonatomic, strong) id userInfo;

/**
 重置刮刮卡涂层.
 */
- (void)reset;

/**
 用这个方法初始化.
 */
- (id)initWithFrame:(CGRect)frame;

@end
