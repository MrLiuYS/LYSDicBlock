//
//  TwoViewController.m
//  DicBlock
//
//  Created by 刘永生 on 2017/3/29.
//  Copyright © 2017年 刘永生. All rights reserved.
//

#import "TwoViewController.h"


typedef void (^DicBlock)(NSString *obj);

@interface TwoViewController ()

@property (nonatomic, strong) NSDictionary *mainDic;/**< <#String#> */

@property (nonatomic, strong) UIButton *touchBtn;/**< <#String#> */

@end

@implementation TwoViewController

+ (void)pushInViewController:(UIViewController *)aViewController dic:(NSDictionary *)dic {
    
    TwoViewController * ctrl = [[TwoViewController alloc]init];
    ctrl.view.backgroundColor = [UIColor whiteColor];
    
    ctrl.mainDic = dic;
    
    [aViewController.navigationController pushViewController:ctrl animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.touchBtn];
    
}

- (void)touchBtn:(UIButton *)btn {
    
    DicBlock dicBlock = self.mainDic[@"block"];
    
    
    dicBlock(@"asdf");
    
}


- (UIButton *)touchBtn {
    
    if(!_touchBtn){
        
        _touchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 300, 100)];
        
        [_touchBtn setTitle:@"点击,在ViewController回调" forState:UIControlStateNormal];
        
        _touchBtn.backgroundColor = [UIColor greenColor];
        
        [_touchBtn addTarget:self action:@selector(touchBtn:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchBtn;
    
}



@end
