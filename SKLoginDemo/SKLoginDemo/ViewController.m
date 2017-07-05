//
//  ViewController.m
//  SKLoginDemo
//
//  Created by AY on 2017/7/5.
//  Copyright © 2017年 AlexanderYeah. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#define MAS_SHORTHAN
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTextFieldWidth [UIScreen mainScreen].bounds.size.width * 0.87
#define kTextFieldHeight 40
#define kTextLeftPadding [UIScreen mainScreen].bounds.size.width * 0.055

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kForgetPwdBtnWidth [UIScreen mainScreen].bounds.size.width * 0.2375

// 输入框距离顶部的高度
#define kTopHeight


@interface ViewController ()


// 0 容器 scrollView
@property (nonatomic,strong)UIScrollView *contentScrollView;

//1 播放器
@property (strong, nonatomic) AVPlayer *player;
//2 用户名
@property (nonatomic,strong) UITextField *nameTextField;
//3 密码
@property (nonatomic,strong)UITextField *pwdTextField;

@end

@implementation ViewController

#pragma mark - 懒加载AVPlayer
- (AVPlayer *)player
{
    if (!_player) {
        //1 创建一个播放item
        NSString *path = [[NSBundle mainBundle]pathForResource:@"register_guide_video.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        // 2 播放的设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;// 永不暂停
        // 3 将图层嵌入到0层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = self.view.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        // 4 播放到头循环播放
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}

#pragma mark - 懒加载 contentScrollView
- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kScreenW , kScreenH)];
        _contentScrollView.delegate = self;
        _contentScrollView.contentSize = CGSizeMake(kScreenW, kScreenH);
        _contentScrollView.userInteractionEnabled =  YES;
        [self.view addSubview:_contentScrollView];
    }
    
    return _contentScrollView;
}

#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    //视频播放
    [self.player play];
    
    // 监听键盘事件
    [self obseverKeyBoard];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

#pragma mark - setupUI
- (void)setupUI
{
    // 1 此处做界面
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder = @"手机号/邮箱";
    _nameTextField.font = [UIFont systemFontOfSize:16.0f];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    [self.contentScrollView addSubview:_nameTextField];
    
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.equalTo(self.contentScrollView.mas_top).equalTo(kForgetPwdBtnWidth);
        
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc]init];
    sepView1.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView1];
    [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(1.5);
        make.left.equalTo(_nameTextField.mas_left).offset(0);
        make.top.equalTo(_nameTextField.mas_bottom).equalTo(0);
        
    }];
    
    //2 此处做界面
    _pwdTextField = [[UITextField alloc]init];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.font = [UIFont systemFontOfSize:16.0f];
    _pwdTextField.borderStyle = UITextBorderStyleNone;
    [self.contentScrollView addSubview:_pwdTextField];
    
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.equalTo(sepView1.mas_bottom).equalTo(20);
        
    }];
    
    //2.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView2];
    [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(1.5);
        make.left.equalTo(_pwdTextField.mas_left).offset(0);
        make.top.equalTo(_pwdTextField.mas_bottom).equalTo(0);
        
    }];
    // 3 按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kRGBColor(24, 154, 204);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentScrollView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(_pwdTextField.mas_left).offset(0);
        make.top.equalTo(sepView2.mas_bottom).equalTo(30);
        
    }];
    
    // 4 忘记密码
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.contentScrollView addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kForgetPwdBtnWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(_pwdTextField.mas_left).offset(0);
        make.top.equalTo(loginBtn.mas_bottom).equalTo(10);
        
    }];
    
    // 5 新用户注册
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.contentScrollView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kForgetPwdBtnWidth);
        make.height.equalTo(kTextFieldHeight);
        make.right.equalTo(_pwdTextField.mas_right).offset(0);
        make.top.equalTo(loginBtn.mas_bottom).equalTo(10);
        
    }];
    
}


#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}
#pragma mark - 所有的点击事件
#pragma mark - 登录按钮的点击
- (void)loginBtnClick
{
    
}
- (void)registBtnClick
{
    
}
- (void)forgetPwdBtnClick
{
    
}

// 键盘取消事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"alex-取消键盘");
    [self.view endEditing:YES];
    
}
// 监听键盘事件
- (void)obseverKeyBoard
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    // 获取这个高度 改变scrollview 的contentsize
#pragma mark - 这个地方就是为了适应小屏幕手机 plus 系列的手机其实都不用适配
    self.contentScrollView.contentSize = CGSizeMake(kScreenW, kScreenH + height);
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // 键盘退出的时候 改变原来的scrollview 的contentsize
    self.contentScrollView.contentSize = CGSizeMake(kScreenW, kScreenH);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
