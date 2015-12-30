//
//  ADWalkthroughTextField.h
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTReParser;

@interface ADWalkthroughTextField : UITextField{
    NSString *_lastAcceptedValue;
    WTReParser *_parser;
}
/**
 *  验证码
 */
@property (strong, nonatomic) NSString *pattern;

@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) UIOffset rightViewPadding;
@property (nonatomic) BOOL showTopLineSeparator;
@property (nonatomic) BOOL showSecureTextEntryToggle;
@property (nonatomic,strong) UIColor *separatorColor;

- (instancetype)initWithLeftViewImage:(UIImage *)image;

/**
 *  text 左边距离 固定 到时候 调整
 */
- (instancetype)initWithLeftLabelText:(NSString *)text;


@end
