//
//  ADVIewStyleGuide.h
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ADViewStyleGuide : NSObject

///fonts
+ (UIFont *)subtitleFont;

///colors
+(UIColor *)colorWithRGBValue:(int)rgbValue;
+(UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue alpha:(CGFloat)alpha;

/**
 *  navgationBar 的背景颜色
 */
+(UIColor *)navgationBarBackgroundColor;


/**
 *  界面的背景颜色
 */
+(UIColor *)backgroundColor;

/**
 *  label 等 字体的颜色 黑色
 */
+(UIColor *)descriptionTextColor;

/**
 *  tabarItemColor 选中 的颜色 橙色
 */
+(UIColor *)tabarItemColor;

/**
 *  分割线的颜色 内置 分割线颜色
 */
+(UIColor *)seperateColor;

/**
 *  部分 深灰色 的 字体颜色
 */
+(UIColor *)subTitleColor;

+(UIColor *)colorOrange;

#pragma mark - 字符串的拼接
// 银行小图片
+ (NSString *)bankSmarllIcon:(NSString *)bankUrl;

+ (NSString *)appRegisterProtocal;

@end
