//
//  HYScratchCardView.m
//  Test
//
//  Created by Shadow on 14-5-23.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "HYScratchCardView.h"

@interface HYScratchCardView ()

@property (nonatomic, strong) UIImageView *surfaceImageView;
@property (nonatomic, strong) UILabel *surfaceLabel;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@property (nonatomic, assign, getter = isOpen) BOOL open;

@end

@implementation HYScratchCardView

- (void)dealloc
{
    if (self.path) {
        CGPathRelease(self.path);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.surfaceLabel = [[UILabel alloc]initWithFrame:self.bounds];
//        self.surfaceLabel.text = @"数据请求中...";
//        self.surfaceLabel.textColor = [UIColor whiteColor];
//        self.surfaceLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.surfaceLabel];
        
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.surfaceImageView.userInteractionEnabled = YES;
        self.surfaceImageView.image = [self imageByColor:[UIColor darkGrayColor]];
        [self addSubview:self.surfaceImageView];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
//        [self.layer addSublayer:self.surfaceLabel.layer];

        [self.layer addSublayer:self.imageLayer];

        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 30.f;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;
        
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        
        self.path = CGPathCreateMutable();
        
        self.canSee = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.isOpen) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathMoveToPoint(self.path, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
        self.shapeLayer.path = path;
        CGPathRelease(path);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.isOpen) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
        self.shapeLayer.path = path;
        CGPathRelease(path);
        
        //haodi
        CGRect rect = CGPathGetPathBoundingBox(self.path);
        double area = CGRectGetHeight(rect)*CGRectGetWidth(rect)/(CGRectGetHeight(self.bounds)*CGRectGetWidth(self.bounds));
        
        if (!_canSee && area > 0.3) {
            if (self.canSeeCompletion) {
                _canSee = YES;
                self.canSeeCompletion(self.userInfo);
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!self.isOpen) {
        [self checkForOpen];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (!self.isOpen) {
        [self checkForOpen];
    }
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
//    DLog(@"result %@",result);

    if (result != nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:ScratchNotification object:@(YES)];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:ScratchNotification object:@(NO)];
    }
    return result;
}

#pragma mark -
- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    self.imageLayer.contents = (id)image.CGImage;
}

- (void)setDescripeText:(NSString *)descripeText{
   UIImage *img = [self CSImage:_image AddText:descripeText];
    self.imageLayer.contents = (id)img.CGImage;
}


- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

- (void)reset
{
    if (self.path) {
        CGPathRelease(self.path);
    }
    self.open = NO;
    self.canSee = NO;
    self.path = CGPathCreateMutable();
    self.shapeLayer.path = NULL;
    self.imageLayer.mask = self.shapeLayer;
    self.descripeText = @"数据请求中...";

}

- (void)checkForOpen
{
    CGRect rect = CGPathGetPathBoundingBox(self.path);
    double area = CGRectGetHeight(rect)*CGRectGetWidth(rect)/(CGRectGetHeight(self.bounds)*CGRectGetWidth(self.bounds));
    
    if (!_canSee && area > 0.3) {
        if (self.canSeeCompletion) {
            _canSee = YES;
            self.canSeeCompletion(self.userInfo);
        }
    }
    
    NSArray *pointsArray = [self getPointsArray];
    for (NSValue *value in pointsArray) {
        CGPoint point = [value CGPointValue];
        if (!CGRectContainsPoint(rect, point)) {
            return;
        }
    }
    
    NSLog(@"完成");
    self.open = YES;
    self.imageLayer.mask = NULL;
    
    if (self.completion) {
        self.completion(self.userInfo);
    }
}

- (NSArray *)getPointsArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGPoint topPoint = CGPointMake(width/2, height/6);
    CGPoint leftPoint = CGPointMake(width/6, height/2);
    CGPoint bottomPoint = CGPointMake(width/2, height-height/6);
    CGPoint rightPoint = CGPointMake(width-width/6, height/2);
    
    [array addObject:[NSValue valueWithCGPoint:topPoint]];
    [array addObject:[NSValue valueWithCGPoint:leftPoint]];
    [array addObject:[NSValue valueWithCGPoint:bottomPoint]];
    [array addObject:[NSValue valueWithCGPoint:rightPoint]];
    
    return array;
}

- (UIImage *)imageByColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -

-(UIImage *)CSImage:(UIImage *)img AddText:(NSString *)text
{
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    view.image = img;
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    [label setNumberOfLines:0];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = text;
    [view addSubview:label];
    
    return [self convertViewToImage:view];
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [v.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    v.layer.contents = nil;
    return image;
    
}

@end
