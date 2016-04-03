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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [APICalls GetFeedGlobal:^(NSDictionary *dictData) {
        NSLog(@"%@",dictData);
    } failed:^(NSString *message) {
        NSLog(@"%@",message);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
