//
//  ADWebViewCtrl.h
//  GoldenRoad
//
//  Created by msl on 15/9/30.
//  Copyright © 2015年 Haodi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestStatus){
    RequestStatusStart,
    RequestStatusFinish,
    RequestStatusError
};

@interface ADWebViewCtrl : UIViewController

@property (nonatomic, strong)NSString *webTitle;

@property (nonatomic, strong)NSString *webUrl;

@property (nonatomic, strong)NSString *webHtmlContent;

@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic, assign)BOOL loadwebTitle;

@property (nonatomic, copy) void (^requestBlock)(BOOL cancelled);

@property (nonatomic, copy) void (^requestStatusBlock)(RequestStatus stauts,NSError *err);

@property (nonatomic, copy) void (^rigntEventBlock)(BOOL cancelled);


@end
