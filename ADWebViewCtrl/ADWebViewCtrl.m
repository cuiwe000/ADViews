//
//  ADWebViewCtrl.m
//  GoldenRoad
//
//  Created by msl on 15/9/30.
//  Copyright © 2015年 Haodi. All rights reserved.
//

#import "ADWebViewCtrl.h"
#import "UIWebView+Util.h"

@interface ADWebViewCtrl ()<UIWebViewDelegate>


@end

@implementation ADWebViewCtrl

-(instancetype)init{
    self = [super init];
    if (self) {
        _loadwebTitle = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = _webTitle;
    if (_webUrl) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest setValue:@"IOS" forHTTPHeaderField:@"client"];
//        [mutableRequest setValue:@"GBK" forHTTPHeaderField:@"charset"];
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        [mutableRequest setValue:[infoDict valueForKey:@"BundleVersionCode"] forHTTPHeaderField:@"version-code"];

        //3.把值覆给request
        request = [mutableRequest copy];
        
        [_webView loadRequest:request];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.leftNavigationItem addTarget:self action:@selector(leftNavigationItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightNavigationItem addTarget:self action:@selector(rightNavigationItemAction:) forControlEvents:UIControlEventTouchUpInside];

    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (_requestBlock) {
        _requestBlock(YES);
    }
}

-(void)leftNavigationItemAction:(id)sender{
    if (_webView.canGoBack) {
        [_webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightNavigationItemAction:(id)sender{
    if (_rigntEventBlock) {
        _rigntEventBlock(YES);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWebHtmlContent:(NSString *)webHtmlContent{
    _webHtmlContent = webHtmlContent;
    
    if (_webHtmlContent) {
        //[_webView loadHTMLString:[self dealWithString:webHtmlContent] baseURL:nil];
        [_webView loadHTMLString:[self dealWithString:webHtmlContent] baseURL:nil];

    }
}

-(void)setWebUrl:(NSString *)webUrl{
    _webUrl = webUrl;
    
}

-(NSString *)dealWithString:(NSString*)webString{
    
    //webString = [webString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    webString = [webString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    webString = [webString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    webString = [webString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    webString = [webString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    webString = [webString stringByReplacingOccurrencesOfString:@"&#34" withString:@"\""];
    webString = [webString stringByReplacingOccurrencesOfString:@"&#92" withString:@"/"];
    webString = [webString stringByReplacingOccurrencesOfString:@"&ampnbsp;" withString:@" "];
    //    webString = [webString stringByReplacingOccurrencesOfString:@"href=\"/" withString:kWebUrlByAddHost(@"href=\"")];
    webString = [webString stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style='max-width:100%;'"];
    //webString = [webString stringByReplacingOccurrencesOfString:@"src=\"/" withString:kWebUrlByAddHost(@"src=\"")];
    
    return webString;
}

#pragma mark - 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (_requestStatusBlock) {
        _requestStatusBlock(RequestStatusStart,nil);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self showloadwebTitle];
    
    if (_requestStatusBlock) {
        _requestStatusBlock(RequestStatusFinish,nil);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
    if (_requestStatusBlock) {
        _requestStatusBlock(RequestStatusError,error);
    }
}


-(void)showloadwebTitle{
    if (_loadwebTitle) {
        NSString *title =  [_webView documentTitle];
        if (title.length>0) {
            self.title = title;
        }
    }
}
@end
