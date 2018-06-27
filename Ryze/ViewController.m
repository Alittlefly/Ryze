//
//  ViewController.m
//  Ryze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "ViewController.h"
#import "RyzeMagicStatics.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [RyzeMagicStatics ryze_addEventName:@"viewDidLoad" withParams:nil];
//    [RyzeMagicStatics ryze_addEventName:@"viewDidLoad" withParams:nil];
//    [RyzeMagicStatics ryze_addEventName:@"viewDidLoad" withParams:nil];

    UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapGesturer];
    
    
//    [self performSelector:@selector(includesa) withObject:nil afterDelay:30];
}

- (void)tapView {
    [RyzeMagicStatics ryze_addEventName:@"tapView" withParams:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
