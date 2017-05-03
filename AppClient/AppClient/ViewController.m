//
//  ViewController.m
//  AppClient
//
//  Created by Lv on 17/4/25.
//  Copyright © 2017年 Lv. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

#define ip

@interface ViewController ()
@property (nonatomic, strong) NSString *ipStr;
@property (nonatomic, strong) NSString *portStr;
@property (nonatomic, strong) NSString *userStr;
@property (nonatomic, strong) NSString *passStr;
@property (nonatomic, strong) UILabel *respondLabel;
@property (nonatomic, strong) UIScrollView *scr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];

}
- (void)setUI{
    
    self.ipStr = @"192.168.1.5";
    self.portStr = @"8000";
    self.userStr = @"zic";
    self.passStr = @"123";
    
    NSArray *tfArr = @[[NSString stringWithFormat:@"ip:init->>%@",self.ipStr],@"port:init->>8000",@"username:init->>zic",@"password:init->>123"];
    for (NSInteger i = 0; i < 4; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, 40 + 60*i, 200, 45)];
        tf.tag = 10+i;
        tf.placeholder = tfArr[i];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tf];
    }
    
    NSArray *btnTitle = @[@"注册",@"验证数据库",@"登录"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *bb = [UIButton buttonWithType:UIButtonTypeCustom];
        [bb setFrame:CGRectMake(self.view.frame.size.width/3*i, i==1?310:280, self.view.frame.size.width/3, 45)];
        [bb setTitle:btnTitle[i] forState:0];
        bb.tag = 102+i;
        bb.backgroundColor = [UIColor grayColor];
        [bb addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bb];
    }
    
    
    self.scr = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 350, self.view.frame.size.width-10, self.view.frame.size.height-350)];
    [self.view addSubview:self.scr];
    
    self.respondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scr.frame.size.width, self.scr.frame.size.height)];
    self.respondLabel.numberOfLines = 0;
    [self.scr addSubview:self.respondLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endeditingg)];
    [self.view addGestureRecognizer:tap];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 160, 40, 30)];
    self.indicator.layer.cornerRadius = 5.0;
    self.indicator.backgroundColor = [UIColor grayColor];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
    [self.view addSubview:self.indicator];
}

- (void)btnclick:(UIButton *)btn{
    [self endeditingg];
    [self getTFtext];
    
    NSString *urlStr = @"";
    switch (btn.tag) {
        case 102:{
            urlStr = @"http://www.baidu.com";
        }break;
        case 103:{
            urlStr = [NSString stringWithFormat:@"http://%@:%@",self.ipStr,self.portStr];
        }break;
        case 104:{
            urlStr = nil;
        }break;
        default:
            break;
    }
    
    [self.indicator startAnimating];
    NSDictionary *parameters = @{@"username":self.userStr,@"password":self.passStr};
    [self postRequestWithURL:urlStr andParameter:parameters whenSuccess:^(id responseObject) {
        [self.indicator stopAnimating];
        NSString *resultStr = [NSString stringWithFormat:@"tag=%ld ##### ---->>>>para=%@ ---->>>>url=%@  ---->>>>responseObject----->%@",btn.tag,parameters,urlStr,responseObject];
//        [self avShowJustWithTitle:resultStr];
        
        self.scr.contentSize = CGSizeMake(0, [self getOneSize:resultStr]);
        [self.respondLabel setFrame:CGRectMake(0, 0, self.scr.frame.size.width-10, [self getOneSize:resultStr])];
        self.respondLabel.text = resultStr;

    } orFail:^(id error) {
        [self.indicator stopAnimating];
        self.respondLabel.text = [NSString stringWithFormat:@"tag=%ld ##### error-->>%@",btn.tag,error];
    }];
}


- (void)getTFtext{
    UITextField *ipp = (UITextField *)[self.view viewWithTag:10];
    UITextField *pordd = (UITextField *)[self.view viewWithTag:11];
    UITextField *usernamee = (UITextField *)[self.view viewWithTag:12];
    UITextField *passwordd = (UITextField *)[self.view viewWithTag:13];
    
    self.ipStr = ipp.text.length==0?@"192.168.1.5":ipp.text;
    self.portStr = pordd.text.length==0?@"8000":pordd.text;
    self.userStr = usernamee.text.length==0?@"zic":usernamee.text;
    self.passStr = passwordd.text.length==0?@"123":passwordd.text;
    
}


- (CGFloat)getOneSize:(NSString *)des{
    return [des boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10,100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 100 ;
}


- (void)postRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBolck
{
    
    NSString *completeURL = [NSString stringWithFormat:@"%@",urlString];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manger POST:completeURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"progress --> %@", uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-------------------------------------------------------->>>>>>>>>>>>>para=%@ ============/n============ url=%@  ============ /n ============ responseObject----->%@",parameters,completeURL,responseObject);
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error --> %@", error);
        failBolck(error);

    }];
}


- (void)avShowJustWithTitle:(NSString *)titStr{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:titStr delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


- (void)endeditingg{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
