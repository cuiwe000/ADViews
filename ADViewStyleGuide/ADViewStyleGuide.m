//
//  ADVIewStyleGuide.m
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import "ADVIewStyleGuide.h"
#import "GoldenRoadAPIConfig.h"

@implementation ADViewStyleGuide

#pragma mark - Fonts
+ (UIFont *)subtitleFont{
    return [UIFont systemFontOfSize:16.0];
}

#pragma mark - Colors
+(UIColor *)colorWithRGBValue:(int)rgbValue{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:alpha];
}

+ (UIColor *)navgationBarBackgroundColor{
//    return [self colorBlue];
    return [UIColor whiteColor];
}

+(UIColor *)backgroundColor{
    return [self colorWithR:240.0f G:241.0f B:243.0f alpha:1];
//    return [UIColor lightGrayColor];
}

+(UIColor *)descriptionTextColor{
//    return [UIColor colorWithRed:187.0/255.0 green:221.0/255.0 blue:237.0/255.0 alpha:1.0];
    return [UIColor blackColor];
}

+ (UIColor *)colorBlue
{
    return [self colorWithR:0 G:135 B:190 alpha:1.0];
}

+ (UIColor *)lightBlue
{
    return [self colorWithR:120 G:220 B:250 alpha:1.0];
}

+ (UIColor *)barColor{
    return [self colorWithRGBValue:0x66ccff];
}

+(UIColor *)colorWhite{
    return [UIColor whiteColor];
}

+(UIColor *)tabarItemColor{
    return [UIColor orangeColor];
}

+(UIColor *)seperateColor{
    return [UIColor colorWithWhite:0.87 alpha:1.0];
}

+(UIColor *)subTitleColor{
    return [UIColor darkGrayColor];
}

+(UIColor *)colorOrange{
    return [self tabarItemColor];
}

#pragma mark - 字符串的拼接
// 银行小图片
+ (NSString *)bankSmarllIcon:(NSString *)bankUrl{
    return  nil;
}

+ (NSString *)appRegisterProtocal{
    return [NSString stringWithFormat:@"%@/pages/memberAgreement/memberprotocal.html",[GoldenRoadAPIConfig baseUrl]];
}
@end
