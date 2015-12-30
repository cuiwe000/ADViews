//
//  ADMainButton.m
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import "ADMainButton.h"

@interface ADMainButton (){
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation ADMainButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([activityIndicator isAnimating]) {
        self.titleLabel.frame = CGRectZero;
        activityIndicator.frame = CGRectMake((self.frame.size.width - activityIndicator.frame.size.width) / 2.0, (self.frame.size.height - activityIndicator.frame.size.height) / 2.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    }
    else{
        self.titleLabel.frame = self.bounds;
    }
}

- (void)configureButton
{
    [self setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9] forState:UIControlStateNormal];
//    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self setColor:[UIColor colorWithRed:0/255.0f green:116/255.0f blue:162/255.0f alpha:1.0f]];
    [self setColor:[UIColor orangeColor]];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.hidesWhenStopped = YES;
    [self addSubview:activityIndicator];
}

- (void)showActivityIndicator:(BOOL)show{
    if (show) {
        [activityIndicator startAnimating];
        self.titleLabel.frame = CGRectZero;
    }
    else{
        [activityIndicator stopAnimating];
        self.titleLabel.frame = self.bounds;
    }

//    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color{
    CGRect fillRect = CGRectMake(0, 0, 11.0, 40.0);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage *mainImage;
    
    ///颜色 转 img
    UIGraphicsBeginImageContextWithOptions(fillRect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:3.0].CGPath);
    CGContextClip(context);
    CGContextFillRect(context, fillRect);
    mainImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:[mainImage resizableImageWithCapInsets:capInsets] forState:UIControlStateNormal];
    [self setBackgroundImage:[mainImage resizableImageWithCapInsets:capInsets] forState:UIControlStateDisabled];

}
@end

#pragma mark - 返回按钮
@implementation ADBackButton

CGFloat const BackButtonExtraHorizontalWidthForSpace    = 30;
UIEdgeInsets const BackButtonTitleEdgeInsets            = {0.0, 0.0, 0, 10.0};
UIEdgeInsets const BackButtonImageEdgeInsets            = {0, -22, 0, 0};

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureButton];
    }
    return self;
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    // Adjust frame to account for the edge insets
    CGRect frame = self.frame;
    frame.size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right + BackButtonExtraHorizontalWidthForSpace;
    self.frame = frame;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right + BackButtonExtraHorizontalWidthForSpace;
    return size;
}

- (void)configureButton
{
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self setTitleEdgeInsets:BackButtonTitleEdgeInsets];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateHighlighted];
    [self setImageEdgeInsets:BackButtonImageEdgeInsets];
    [self setImage:[UIImage imageNamed:@"btn-back-chevron"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"btn-back-chevron-tapped"] forState:UIControlStateHighlighted];
    [self setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
}

@end


