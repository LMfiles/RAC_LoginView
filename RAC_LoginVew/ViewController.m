//
//  ViewController.m
//  RAC_LoginVew
//
//  Created by 马朋飞 on 2017/12/9.
//  Copyright © 2017年 马朋飞. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *userSignal = self.userTextField.rac_textSignal;
    RACSignal *pasSignal = self.psdTextField.rac_textSignal;
    RACSignal *enabled = [[RACSignal combineLatest:@[userSignal, pasSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value.first length] > 0 && [value.second length] >5);
    }];
    
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:enabled signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"登录中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登录"];
                [subscriber sendCompleted];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    @weakify(self)
    [[self.loginBtn.rac_command executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        @strongify(self)
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
            [self.loginBtn setTitle:x forState:UIControlStateNormal];
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
