//
//  ADMainButton.h
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import <UIKit/UIKit.h>

///例如 登录按钮
@interface ADMainButton : UIButton

- (void)showActivityIndicator:(BOOL)show;
- (void)setColor:(UIColor *)color;

@end


///返回 按钮
@interface ADBackButton : UIButton

@end
