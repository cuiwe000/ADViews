//
//  ADWalkthroughTextField.m
//  CarPurifier
//
//  Created by msl on 15/8/25.
//  Copyright (c) 2015年 Haodi. All rights reserved.
//

#import "ADWalkthroughTextField.h"

#import "WTReParser.h"

@interface ADWalkthroughTextField (){
    CGFloat LeftLabelTextWidth;
}

@property (nonatomic, strong) UIImage *leftViewImage;
@property (nonatomic, strong) UIButton *secureTextEntryToggle;
@property (nonatomic, strong) UIImage *secureTextEntryImageVisible;
@property (nonatomic, strong) UIImage *secureTextEntryImageHidden;

@property (nonatomic, strong) NSString *leftLabelText;

@end

@implementation ADWalkthroughTextField

-(instancetype)init{
    self = [super init];
    if (self) {
        _lastAcceptedValue = nil;
        _parser = nil;
        [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
        
        self.textInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        self.backgroundColor = [UIColor whiteColor];
        self.separatorColor = [UIColor colorWithWhite:0.87 alpha:1.0];
        self.layer.cornerRadius = 1.0f;
        self.clipsToBounds = YES;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        LeftLabelTextWidth = 55.0f;

        self.showTopLineSeparator = NO;
        self.showSecureTextEntryToggle = NO;
        
        self.secureTextEntryImageVisible = [UIImage imageNamed:@"icon-secure-text-visible"];
        self.secureTextEntryImageHidden = [UIImage imageNamed:@"icon-secure-text"];
        
        self.secureTextEntryToggle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        [self.secureTextEntryToggle addTarget:self action:@selector(secureTextEntryToggleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.secureTextEntryToggle];
        
        [self updateSecureTextEntryToggleImage];

    }
    return self;
}

-(instancetype)initWithLeftViewImage:(UIImage *)image{
    self = [self init];
    if (self) {
        self.leftViewImage = image;
        self.leftView = [[UIImageView alloc] initWithImage:image];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (instancetype)initWithLeftLabelText:(NSString *)text{
    self = [self init];
    if (self) {
        self.leftLabelText = text;
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.font = self.font;
        leftLabel.text = text;
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.textColor =[UIColor darkGrayColor];
        leftLabel.backgroundColor = [UIColor clearColor];
        self.leftView = leftLabel;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (void)dealloc
{
    _lastAcceptedValue = nil;
    _parser = nil;
    [self removeTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
}

-(void)drawRect:(CGRect)rect{
    
    ///绘制顶部分割线
    if (_showTopLineSeparator) {
        CGContextRef context = UIGraphicsGetCurrentContext();
           
        UIBezierPath *bpath =[UIBezierPath bezierPath];
        // 添加路径[1条点(100,100)到点(200,100)的线段]到path
        [bpath moveToPoint:CGPointMake(CGRectGetMinX(rect)+_textInsets.left , CGRectGetMinY(rect))];
        [bpath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        
        // 设置描边宽度（为了让描边看上去更清楚）
        [bpath setLineWidth:[[UIScreen mainScreen] scale] / 2.0];
        
        CGContextAddPath(context, bpath.CGPath);
        CGContextSetStrokeColorWithColor(context, _separatorColor.CGColor);
        CGContextStrokePath(context);
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.secureTextEntryToggle.hidden = !self.showSecureTextEntryToggle;
    if (self.showSecureTextEntryToggle) {
        self.secureTextEntryToggle.frame = CGRectIntegral(CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.secureTextEntryToggle.frame),
                                                                     (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.secureTextEntryToggle.frame)) / 2.0,
                                                                     CGRectGetWidth(self.secureTextEntryToggle.frame),
                                                                     CGRectGetHeight(self.secureTextEntryToggle.frame)));
        [self bringSubviewToFront:self.secureTextEntryToggle];
    }
}

-(CGRect)calculateTextRectForBounds:(CGRect)bounds{
    CGRect returnRect;
    if (_leftViewImage) {
        CGFloat leftViewWidth = _leftViewImage.size.width;
        returnRect = CGRectMake(leftViewWidth+_textInsets.left*2, _textInsets.top, bounds.size.width-leftViewWidth-_textInsets.left*2, bounds.size.height-_textInsets.top-_textInsets.bottom);
    }
    else if(_leftLabelText){
        CGSize size = [self sizeForString:_leftLabelText font:self.font andWidth:CGFLOAT_MAX];
        if (size.width > LeftLabelTextWidth) {
            LeftLabelTextWidth = size.width;
        }
        CGFloat leftViewWidth = LeftLabelTextWidth;
        returnRect = CGRectMake(leftViewWidth+_textInsets.left*2, _textInsets.top, bounds.size.width-leftViewWidth-_textInsets.left*2, bounds.size.height-_textInsets.top-_textInsets.bottom);
    }
    else{
        returnRect = CGRectMake(_textInsets.left, _textInsets.top, bounds.size.width - _textInsets.left - _textInsets.right, bounds.size.height - _textInsets.top - _textInsets.bottom);

    }
    
    if (self.showSecureTextEntryToggle) {
        returnRect.size.width -= CGRectGetWidth(self.secureTextEntryToggle.frame);
    }
    
    if (self.rightView && self.rightViewMode != UITextFieldViewModeNever) {
        returnRect.size.width -= CGRectGetWidth(self.rightView.frame);
    }
    
    return CGRectIntegral(returnRect);
}



-(CGRect)textRectForBounds:(CGRect)bounds{
    return [self calculateTextRectForBounds:bounds];
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return [self calculateTextRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    if (_leftViewImage != nil) {
        return CGRectIntegral(CGRectMake(_textInsets.left, (CGRectGetHeight(bounds) - _leftViewImage.size.height) / 2.0, _leftViewImage.size.width, _leftViewImage.size.height));
    }
    else if(_leftLabelText.length > 0){
        return CGRectIntegral(CGRectMake(_textInsets.left, 0, LeftLabelTextWidth, CGRectGetHeight(bounds)));
    }

    return [super leftViewRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= _rightViewPadding.horizontal;
    textRect.origin.y -= _rightViewPadding.vertical;
    
    return [super rightViewRectForBounds:bounds];
}

#pragma mark - security text entry Button handler

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    [super setSecureTextEntry:secureTextEntry];
    [self updateSecureTextEntryToggleImage];
}

-(void)secureTextEntryToggleAction:(id)sender{
    
    self.secureTextEntry = !self.secureTextEntry;
    
    UITextRange *currentTextRange = self.selectedTextRange;
    [self becomeFirstResponder];
    [self setSelectedTextRange:currentTextRange];
}

-(void)updateSecureTextEntryToggleImage{
    UIImage  *image = self.isSecureTextEntry?self.secureTextEntryImageHidden:self.secureTextEntryImageVisible;
    [self.secureTextEntryToggle setImage:image forState:UIControlStateNormal];
}

#pragma mark - 正则表达验证
- (void)setPattern:(NSString *)pattern
{
    if (pattern == nil || [pattern isEqualToString:@""])
        _parser = nil;
    else
        _parser = [[WTReParser alloc] initWithPattern:pattern];
}

- (NSString*)pattern
{
    return _parser.pattern;
}

- (void)formatInput:(UITextField *)textField
{
    if (_parser == nil) return;
    
    __block WTReParser *localParser = _parser;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *formatted = [localParser reformatString:textField.text];
        if (formatted == nil)
            formatted = _lastAcceptedValue;
        else
            _lastAcceptedValue = formatted;
        NSString *newText = formatted;
        if (![textField.text isEqualToString:newText]) {
            textField.text = formatted;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    });
}

- (CGSize) sizeForString:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGSize sizeToFit =[value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return sizeToFit;
}



@end
