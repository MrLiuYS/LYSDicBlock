//
//  ViewController.m
//  DicBlock
//
//  Created by 刘永生 on 2017/3/29.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "ViewController.h"

#import "TwoViewController.h"

typedef void (^DicBlock)(NSString *obj);

@interface ViewController ()

@property (nonatomic, copy) DicBlock dicBlock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block ViewController *weakSelf = self;
    
    _dicBlock = ^(NSString *obj){
        
        NSLog(@"接收TwoViewController的数据:%@",obj);
        
        weakSelf.view.backgroundColor = [UIColor lightTextColor];
        
    };
    
}

- (IBAction)touchGoTwo:(id)sender {
    
    [TwoViewController pushInViewController:self
                                        dic:@{@"block": _dicBlock}];
    
    
}

@end
