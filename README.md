

# 谈iOS组件化

## 为什么要做模块组件化

*   代码质量,规范都会更高
*   代码耦合度低
*   分工可以更明确
*   如果使用pod集成回滚应该会更方便
*   使用cocoapods,分功能编译.会更快.但是目前并没有使用.
*   可以避免忘记对文件的target,进行勾选

这里说一下:多人开发的情况.有些人的管理方式是,这个需求A来开发这个模块,下一个版本B来开发这个版本,美其名曰:可以互相熟悉对方的代码.其实这样子有很大的弊端.

1.  之后确认需求会变得不明确,当A开发完成之后,有B接收,如果B没有完全明白需求的情况下,就直接进行修改,将会出现未知的问题;反之,A在接收B 之后的代码,同样会有这个问题
2. 当经过多次A->B->A->...,当出现一个线上Bug之后,这个bug应该是谁来负责,谁来修改?
3.  代码的质量,每个人有每个人的开发习惯,解决问题的方法也有很多,水平的高低也不尽相同.当两个人轮流开发同一份文件的时候.将会不同程度的影响到开发的质量.

在我看来多人开发模式,应该是这样的:
每个模块都有明细的划分, 
当这个模块有需求变更的时候,就都应该由相应的开发者来进行开发,当然有存在情况这个开发者A来不及开发.如果是这个问题.可以由另外一个开发者B进行辅助开发,当B开发完成之后,B向A开发者说明,具体改动,之后A对B代码可以进行整理.

## 基础组件

*   网络请求
*   loading
*   string,date等类型的组件
*   一切封装的UI控件:比如日历,浮标
*   等等

## 原则

*   业务组件之间不能有依赖关系


## 是否要去model?

*   去model,不好确定Dic参数的内容类型
*   不去model,两个业务组件都可能去依赖它,也都可能去更改这个model.

### 信息披露

去model,所有的所有都要放在头文件里面写详细的注释.
如果不去model,在model里面定义出来


## 组件化实现

这里参考[CTMediator](https://github.com/casatwy/CTMediator)的模式进行组件化.

![](https://ww2.sinaimg.cn/large/006tNc79gy1fe5ujr9yhcj311018rtau.jpg)


## 反向调用

当A调用B为正向调用的时候.当B要调用A的方法的时候就很可能会出现耦合的情况.这里我们可以使用Dic-block的方式实现解耦.

```ruby
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
```
```ruby
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
```

使用CTMediator 在利用block 让模块与模块完全解耦.

虽然实现起来会多几个步骤.但是对以后来的开发还是有很多帮助的.



