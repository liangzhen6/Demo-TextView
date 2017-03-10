//
//  ViewController.m
//  TextViewDemo
//
//  Created by shenzhenshihua on 2017/3/7.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//
/*
 NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);

 
 */
#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottomHCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHCons;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic,assign)NSInteger textOldH;

@property(nonatomic,assign)NSInteger maxTextH;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initController];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)initController{
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.scrollsToTop = NO;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.font = [UIFont systemFontOfSize:17];
    //当textview的字符串为0时发送（rerurn）键无效
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    //键盘return样式变成发送
    self.textView.returnKeyType = UIReturnKeySend;
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.textView.font.lineHeight * 4 + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);

}

#pragma mark ================textViewdelegate=========================
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码

        
        textView.text = nil;
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
  NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);
    if (_textOldH!=height) {
        // 最大高度，可以滚动
        self.textView.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        if (self.textView.scrollEnabled==NO) {
            _backViewHCons.constant = height + 10;//距离上下边框各为5，所以加10
            [self.view layoutIfNeeded];
        }
        
        _textOldH = height;
        
    }
    

}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // 获取键盘弹出时长
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
     CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    _backViewBottomHCons.constant = keyBoardFrame.origin.y != screenH?keyBoardFrame.size.height:0;

    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
