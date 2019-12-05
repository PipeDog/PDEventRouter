//
//  ViewController.m
//  PDEventRouter
//
//  Created by liang on 2019/12/5.
//  Copyright © 2019 liang. All rights reserved.
//

#import "ViewController.h"
#import "PDEventRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PDEventRouter *router = [PDEventRouter globalRouter];
    
    [router request:@"pipe://event/demo" params:nil completion:^(PDEventResponse * _Nonnull response) {
        NSLog(@"%@", response);
    }];
}

@end
