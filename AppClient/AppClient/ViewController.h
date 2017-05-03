//
//  ViewController.h
//  AppClient
//
//  Created by Lv on 17/4/25.
//  Copyright © 2017年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailBlock)(id error);





@interface ViewController : UIViewController
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

///**
// *  AF的get请求
// */
//- (void)getRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBolck;
//
///**
// *  AF的post请求
// */
//- (void)postRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBolck;


@end

