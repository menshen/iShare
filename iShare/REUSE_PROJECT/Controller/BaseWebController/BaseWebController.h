//
//  BaseWebController.h
//  易商
//
//  Created by 伍松和 on 14/11/3.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebController : BaseViewController
@property(nonatomic,copy)NSString* URLString;
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)loadURL:(NSURL*)URL;
@end
