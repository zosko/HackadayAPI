//
//  ViewController.m
//  Hackaday
//
//  Created by Bosko Petreski on 3/31/16.
//  Copyright © 2016 Bosko Petreski. All rights reserved.
//

#import "ViewController.h"
#import "APICalls.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - IBActions
-(IBAction)onBtnAuthorize:(UIButton *)sender{
    [APICalls GetAccessToken:self];
}
-(IBAction)onBtnTest:(UIButton *)sender{
    [APICalls GetMe:^(NSDictionary *dictData) {
        NSLog(@"get me: %@",dictData);
    } failed:^(NSString *message) {
        NSLog(@"error: %@",message);
    }];
}

#pragma mark - UIViewDelegates
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [APICalls GetFeedGlobal:^(NSDictionary *dictData) {
        NSLog(@"get feed: %@",dictData);
    } failed:^(NSString *message) {
        NSLog(@"error: %@",message);
    }];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
