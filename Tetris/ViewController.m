//
//  ViewController.m
//  Tetris
//
//  Created by 张欣欣 on 2017/10/9.
//  Copyright © 2017年 zxx. All rights reserved.
//

#import "ViewController.h"
#import "RussiaView.h"
#import "ElementView.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic, strong) RussiaView *russiaView;
/** 当前显示元件 */
@property (nonatomic, strong) ElementView *elementView;
/** 下一个元件 */
@property (nonatomic, strong) UIView *nextElementView;
/** 下一个元件类型 */
@property (nonatomic, assign) NSInteger nextTypeElement;
/** 标记数组总数 */
@property (nonatomic, strong) NSMutableArray *markArrM;
/** 单个元件标记数 */
@property (nonatomic, strong) NSMutableArray *elementArrM;
/** 元件方向 */
@property (nonatomic, strong) NSString *direction;
/** 定时器 */
@property (nonatomic, strong) NSTimer *downTimer;
/** 元件下降时间 */
@property (nonatomic, assign) NSTimeInterval moveSpeed;
/** 元件类型 */
@property (nonatomic, assign) NSInteger typeElement;
/** 得分 */
@property (nonatomic, strong) UILabel *score;
/** 得分 */
@property (nonatomic, assign) NSInteger scoreNum;

@property (nonatomic, strong) AVAudioPlayer *av;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.russiaView == nil) {
        self.russiaView =  [[RussiaView alloc]init];
        //        self.russiaView.backgroundColor = [UIColor grayColor];
        self.russiaView.clipsToBounds = YES;
        [self.view addSubview:self.russiaView];
        [self.russiaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.offset(CGSizeMake(Kelement_W*10, Kelement_W*20));
            //            make.centerY.equalTo(self.view);
            make.left.offset(50);
            make.top.offset(150);
        }];
    }
    self.scoreNum = 0;
    [self setControlButton];
    //创建音效文件URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ShangHaiTan.mp3" withExtension:nil];
    AVAudioPlayer *av = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    av.numberOfLoops = -1;
    [av prepareToPlay];
    self.av = av;
}
-(NSMutableArray *)markArrM{
    if (_markArrM == nil) {
        _markArrM = [NSMutableArray array];
    }
    return _markArrM;
}
-(NSMutableArray *)elementArrM{
    if (_elementArrM == nil) {
        _elementArrM = [NSMutableArray array];
    }
    return _elementArrM;
}
#pragma mark - 控制按钮
-(void)setControlButton{
    [self setButtonWithName:@"音效" selectdeName:@"静音" index:0];
    [self setButtonWithName:@"开始" selectdeName:@"暂停" index:1];
    [self setButtonWithName:@"重玩" selectdeName:@"重玩" index:2];
    UIButton *leftButton = [self directionButton];
    [leftButton addTarget:self action:@selector(leftMove) forControlEvents:UIControlEventTouchDown];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(-100);
        make.size.offset(CGSizeMake(50, 50));
    }];
    UIButton *rightButton = [self directionButton];
    [rightButton addTarget:self action:@selector(rightMove) forControlEvents:UIControlEventTouchDown];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30+40+50);
        make.bottom.equalTo(leftButton);
        make.size.offset(CGSizeMake(50, 50));
    }];
    UIButton *downButton = [self directionButton];
    [downButton addTarget:self action:@selector(speedUpMove) forControlEvents:UIControlEventTouchUpInside];
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30+45);
        make.bottom.equalTo(leftButton).offset(40);
        make.size.offset(CGSizeMake(50, 50));
    }];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    // 设置能识别到长按手势的最小的长按时间
    longPress.minimumPressDuration = 0.1;
    [downButton addGestureRecognizer:longPress];
    UIButton *upButton = [self directionButton];
    [upButton addTarget:self action:@selector(slowDownMove) forControlEvents:UIControlEventTouchDown];
    [upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30+45);
        make.bottom.equalTo(leftButton).offset(-40);
        make.size.offset(CGSizeMake(50, 50));
    }];
    UIButton *revolveButton = [self directionButton];
    [revolveButton addTarget:self action:@selector(revolveButton) forControlEvents:UIControlEventTouchDown];
    revolveButton.layer.cornerRadius = 50;
    [revolveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.offset(CGSizeMake(100, 100));
        make.right.offset(-30);
        make.bottom.equalTo(leftButton).offset(40);
    }];
    self.score = [[UILabel alloc]init];
    self.score.text = @"得分:0";
    [self.view addSubview:self.score];
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-50);
        make.centerY.equalTo(self.view);
    }];
    UILabel *nextElement = [[UILabel alloc]init];
    nextElement.text = @"下一个";
    [self.view addSubview:nextElement];
    [nextElement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.score);
        make.top.equalTo(self.score.bottom).offset(20);
    }];
    self.nextElementView = [[UIView alloc]init];
    [self.view addSubview:self.nextElementView];
    [self.nextElementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextElement);
        make.top.equalTo(nextElement.bottom).offset(10);
        make.size.offset(CGSizeMake(45, 45));
    }];
    self.nextTypeElement = arc4random() % 8;
    //   self.nextTypeElement = 5;
}

-(UIButton *)directionButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    return button;
}
-(void)setButtonWithName:(NSString *)name selectdeName:(NSString *)selectName index:(NSInteger )index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:selectName forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchDown];
    button.tag = index+2004;
    button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [button setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20-index*60);
        make.size.offset(CGSizeMake(50, 30));
        make.top.equalTo(self.russiaView.bottom).offset(10);
    }];
}
#pragma mark - 点击事件
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    // 判断手势识别当前的状态
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.downTimer setFireDate:[NSDate date]];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [self.downTimer setFireDate:[NSDate date]];
    }
}
-(void)didBeginButton{
    self.moveSpeed = 0.1;
    if (self.elementView == nil) {
        self.elementView =[[ElementView alloc]init];
        self.elementView.frame = CGRectMake(Kelement_W*4+0.5, -Kelement_W*3+0.5, Kelement_W*4, Kelement_W*4);
        [self.russiaView addSubview:self.elementView];
        self.typeElement = self.nextTypeElement;
        self.elementArrM = [self.elementView setElementIndexWithIndex:self.typeElement];
        self.nextTypeElement = arc4random() % 8;
        //        self.nextTypeElement = 6;
        for (UIView *view in self.view.subviews) {
            if (view.tag == 2048) {
                [view removeFromSuperview];
            }
        }
        ElementView *view = [[ElementView alloc]init];
        view.frame = self.nextElementView.frame;
        view.tag = 2048;
        [self.view addSubview:view];
        [view setElementIndexWithIndex:self.nextTypeElement];
        self.nextElementView = view;
        self.direction = @"down";
    }
    if (self.downTimer == nil) {
        self.downTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(beginGame) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.downTimer forMode:NSRunLoopCommonModes];
        [self.downTimer fire];
        //        self.score = 0;
    }else{
        [self.downTimer setFireDate:[NSDate date]];
    }
}
-(void)beginGame{
    [self beginAnimate];
    [self isCancelLineWith:(Kelement_W*20-self.elementView.y)/Kelement_W];
}
//下落时判断
-(void)beginAnimate{
    for (int i = 0; i<self.elementArrM.count; i++) {
        NSInteger temp = [self.elementArrM[i] integerValue];
        temp -= 10;
        self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
    }
    char temp = 0;
    for (NSString *str in self.elementArrM) {
        if ([str integerValue] >=180&&[self.markArrM containsObject:str]) {
            [self.downTimer invalidate];
            self.downTimer = nil;
            [SVProgressHUD showInfoWithStatus:@"游戏结束"];
            UIView *blackView = [[UIView alloc]init];
            blackView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
            blackView.frame = CGRectMake(0, 300, Kelement_W*10, Kelement_W*20);
            [self.russiaView addSubview:blackView];
            [UIView animateWithDuration:1.0 animations:^{
                blackView.y = 0;
            } completion:^(BOOL finished) {
                for (UIView *view in self.russiaView.subviews) {
                    if (view.tag != 0) {
                        [view removeFromSuperview];
                    }
                }
                [UIView animateWithDuration:1.0 animations:^{
                    blackView.y = 300;
                }completion:^(BOOL finished) {
                    for (UIButton *button in self.view.subviews) {
                        if (button.tag == 2005) {
                            button.selected = NO;
                        }
                    }
                    [self.markArrM removeAllObjects];
                    self.score.text = @"得分:0";
                    [SVProgressHUD dismiss];
                }];
            }];
            return;
        }
        if ( [str integerValue]<0||[self.markArrM containsObject:str]) {
            temp = 1;
            break;
        }
    }
    if (temp == 0) {
        [self dropAnimate];
    }else{
        for (int i = 0; i<self.elementArrM.count; i++) {
            NSInteger temp = [self.elementArrM[i] integerValue];
            temp += 10;
            self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
        }
        for (int i = 0; i<self.elementArrM.count; i++) {
            NSInteger temp = [self.elementArrM[i] integerValue];
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(temp%10*Kelement_W,Kelement_W*20-(temp+10)/10*Kelement_W, Kelement_W, Kelement_W);
            view.tag = temp+1;
            view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
            [self.russiaView addSubview:view];
        }
        [self.markArrM addObjectsFromArray:self.elementArrM];
        [self.elementView removeFromSuperview];
        self.elementView = nil;
        [self didBeginButton];
    }
}
//开始下降
-(void)dropAnimate{
    [UIView animateWithDuration:self.moveSpeed animations:^{
        self.elementView.y += Kelement_W;
    }completion:^(BOOL finished) {
        //        [self isCancelLineWith:(Kelement_W*20-self.elementView.y)/Kelement_W];
    }];
}
//系统按钮 重玩 开始 音效
-(void)didButton:(UIButton *)button{
    if (button.tag-2004 == 1) {
        if (button.isSelected) {
            button.selected = NO;
            [self.downTimer setFireDate:[NSDate distantFuture]];
        }else{
            button.selected = YES;
            [self didBeginButton];
        }
    }else if (button.tag-2004 == 2){
        [self.russiaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.elementView removeFromSuperview];
        self.elementView = nil;
        [self.markArrM removeAllObjects];
        self.scoreNum = 0;
        [self didBeginButton];
        for (UIButton *button in self.view.subviews) {
            if (button.tag == 2005) {
                button.selected = YES;
            }
        }
        self.score.text = @"得分:0";
    }else{
        if (button.isSelected) {
            button.selected = NO;
            [self.av pause];
        }else{
            button.selected = YES;
            [self.av play];
        }
        //        if ([self.av isPlaying]) {
        //            [self.av pause];
        //        }else{
        //            [self.av play];
        //        }
    }
}
//左移
-(void)leftMove{
    [self changeMoveWithDirection:@"left"];
}
//右移
-(void)rightMove{
    [self changeMoveWithDirection:@"right"];
}
-(void)changeMoveWithDirection:(NSString *)direction{
    [self.downTimer setFireDate:[NSDate distantFuture]];
    for (int i = 0; i<self.elementArrM.count; i++) {
        NSInteger temp = [self.elementArrM[i] integerValue];
        if ([direction isEqualToString:@"right"]) {
            if ((temp+1)%10 == 0||[self.markArrM containsObject:[NSString stringWithFormat:@"%ld",(temp+1)]]) {
                [self.downTimer setFireDate:[NSDate date]];
                return;
            }
        }else{
            if (temp%10 == 0||[self.markArrM containsObject:[NSString stringWithFormat:@"%ld",(temp-1)]]) {
                [self.downTimer setFireDate:[NSDate date]];
                return;
            }
        }
    }
    for (int i = 0; i<self.elementArrM.count; i++) {
        NSInteger temp = [self.elementArrM[i] integerValue];
        if ([direction isEqualToString:@"right"]) {
            temp += 1;
        }else{
            temp -= 1;
        }
        self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
    }
    char temp = 0;
    for (NSString *str in self.elementArrM) {
        if ( [str integerValue]<0||[self.markArrM containsObject:str]) {
            temp = 1;
            break;
        }
    }
    if (temp == 0) {
        [UIView animateWithDuration:0.05 animations:^{
            if ([direction isEqualToString:@"right"]) {
                self.elementView.x += Kelement_W;
            }else{
                self.elementView.x -= Kelement_W;
            }
        }completion:^(BOOL finished) {
            [self.downTimer setFireDate:[NSDate date]];
        }];
    }else{
        [self.downTimer setFireDate:[NSDate date]];
    }
}
//加速向下
-(void)speedUpMove{
    //     self.moveSpeed -= 0.05;
    [self.downTimer setFireDate:[NSDate date]];
}
//减速向下
-(void)slowDownMove{
    //    self.moveSpeed = 0.5;
}
//变形
-(void)revolveButton{
    switch (self.typeElement) {
        case 0:
        {
            NSInteger temp;
            if ([self.direction isEqualToString:@"down"]) {
                for (int i = 0; i<4; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    if (temp%10<1||temp%10>7) {
                        return;
                    }
                    temp += 9-9*i;
                    if ([self.markArrM containsObject:[NSString stringWithFormat:@"%ld",temp]]) {
                        return;
                    }
                }
                for (int i = 0; i<4; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp += 9-9*i;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
                self.elementView.y += Kelement_W/2;
                self.elementView.x += Kelement_W/2;
                self.direction = @"up";
            }else if ([self.direction isEqualToString:@"up"]){
                for (int i = 0; i<4; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= 9-9*i;
                    if ([self.markArrM containsObject:[NSString stringWithFormat:@"%ld",temp]]) {
                        return;
                    }
                }
                for (int i = 0; i<4; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= 9-9*i;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2*3);
                self.elementView.y -= Kelement_W/2;
                self.elementView.x -= Kelement_W/2;
                self.direction = @"down";
            }
        }
            break;
        case 1:
        {
            //判断是否变形
            if ([self isRevolveSucceed]) {
                return;
            }
            NSInteger temp;
            if ([self.direction isEqualToString:@"down"]) {
                temp = [self.elementArrM[0] integerValue];
                temp += 20;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[1] integerValue];
                temp += 11;
                self.elementArrM[1] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[2] integerValue];
                temp += 2;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM.lastObject integerValue];
                temp += 9;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"up";
            }else if ([self.direction isEqualToString:@"up"]){
                for (int i = 0; i<3; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= (18-9*i);
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[3] integerValue];
                temp += 11;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"right";
            }else if ([self.direction isEqualToString:@"right"]){
                for (int i = 2; i<4; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= 20;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[0] integerValue];
                temp -= 2;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"left";
            }else if ([self.direction isEqualToString:@"left"]){
                temp = [self.elementArrM[1] integerValue];
                temp -= 2;
                self.elementArrM[1] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[2] integerValue];
                temp += 18;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"down";
            }
            self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
        }
            break;
        case 2:
        {
            //判断是否变形
            if ([self isRevolveSucceed]) {
                return;
            }
            NSInteger temp;
            if ([self.direction isEqualToString:@"down"]) {
                for (int i = 0; i<3; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp += 9-i*9;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[3] integerValue];
                temp += 20;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"up";
            }else if ([self.direction isEqualToString:@"up"]){
                for (int i = 0; i<3; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= 9-i*9;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[3] integerValue];
                temp += 2;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"right";
            }else if ([self.direction isEqualToString:@"right"]){
                for (int i = 0; i<3; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp += 9-i*9;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[3] integerValue];
                temp -= 20;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"left";
            }else if ([self.direction isEqualToString:@"left"]){
                for (int i = 0; i<3; i++) {
                    temp = [self.elementArrM[i] integerValue];
                    temp -= 9-i*9;
                    self.elementArrM[i] = [NSString stringWithFormat:@"%ld",temp];
                }
                temp = [self.elementArrM[3] integerValue];
                temp -= 2;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"down";
            }
            self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
        }
            break;
        case 3:
        {
            //判断是否变形
            if ([self isRevolveSucceed]) {
                return;
            }
            NSInteger temp;
            if ([self.direction isEqualToString:@"down"]) {
                temp = [self.elementArrM[0] integerValue];
                temp -= 9;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"up";
            }else if ([self.direction isEqualToString:@"up"]){
                temp = [self.elementArrM[3] integerValue];
                temp -= 11;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"right";
            }else if ([self.direction isEqualToString:@"right"]){
                temp = [self.elementArrM[2] integerValue];
                temp += 9;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"left";
            }else if ([self.direction isEqualToString:@"left"]){
                temp = [self.elementArrM[0] integerValue];
                temp += 9;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[2] integerValue];
                temp -= 9;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[3] integerValue];
                temp += 11;
                self.elementArrM[3] = [NSString stringWithFormat:@"%ld",temp];
                self.direction = @"down";
            }
            self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
        }
            break;
        case 5:
        case 6:
        {
            //判断是否变形
            if ([self isRevolveSucceed]) {
                return;
            }
            if ([self.direction isEqualToString:@"down"]) {
                NSInteger temp = [self.elementArrM[0] integerValue];
                temp += 20;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[2] integerValue];
                temp += 2;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
                self.direction = @"up";
            }else{
                NSInteger temp = [self.elementArrM[0] integerValue];
                temp -= 20;
                self.elementArrM[0] = [NSString stringWithFormat:@"%ld",temp];
                temp = [self.elementArrM[2] integerValue];
                temp -= 2;
                self.elementArrM[2] = [NSString stringWithFormat:@"%ld",temp];
                self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2*3);
                self.direction = @"down";
            }
        }
            break;
        default:
            break;
    }
}
//判断是否消行
-(void)isCancelLineWith:(NSInteger)index{
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < index; i++) {
        NSMutableArray *tempArrM = [NSMutableArray array];
        for (int j = 0; j<self.markArrM.count; j++) {
            NSInteger temp = [self.markArrM[j] integerValue];
            if (temp/10 == i) {
                [tempArrM addObject:[NSString stringWithFormat:@"%ld",temp]];
            }
        }
        [arrM addObject:tempArrM];
    }
    for (int i = 0; i<arrM.count; i++) {
        NSArray *arr = [NSArray arrayWithArray:arrM[i]];
        if (arr.count>9) {//消行
            [self.downTimer setFireDate:[NSDate distantFuture]];
            self.scoreNum += 1;
            self.score.text = [NSString stringWithFormat:@"得分:%ld",self.scoreNum];
            NSInteger indexY =Kelement_W*20 - ([arr.firstObject integerValue]/10+1)*Kelement_W;
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
            view.frame =CGRectMake(0, indexY, Kelement_W*10, Kelement_W);
            [self.russiaView addSubview:view];
            for (id tag in arr) {
                UIView *view = [self.russiaView viewWithTag:([tag integerValue]+1)];
                [view removeFromSuperview];
                view = nil;
                [self.markArrM removeObject:tag];
            }
            //消行 动画效果
            [UIView animateWithDuration:0.2 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                for (UIView *view in self.russiaView.subviews) {
                    if (view.tag >[arr[0] integerValue]) {
                        view.y += Kelement_W;
                        view.tag -= 10;
                    }
                }
                for (int j = 0; j<self.markArrM.count; j++) {
                    if ([self.markArrM[j] integerValue] > [arr[0] integerValue]) {
                        NSInteger temp = [self.markArrM[j] integerValue] - 10;
                        self.markArrM[j] = [NSString stringWithFormat:@"%ld",temp];
                    }
                }
                [self.downTimer setFireDate:[NSDate date]];
            }];
        }
    }
}
-(BOOL)isRevolveSucceed{
    //判断是否超出游戏空间
    self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2);
    if ((self.elementView.frame.origin.x+self.elementView.frame.size.width)<Kelement_W*10&&self.elementView.frame.origin.x>0) {
    }else{
        self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2*3);
        return YES;
    }
    //判断是否和其他view有交集
    for (UIView *view in self.russiaView.subviews) {
        if ([view isKindOfClass:[ElementView class]]) {
            continue;
        }
        if (CGRectIntersectsRect(self.elementView.frame, view.frame)) {
            self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2*3);
            return YES;
        }
    }
    self.elementView.transform = CGAffineTransformRotate(self.elementView.transform, M_PI_2*3);
    return NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.av stop];
    [self.downTimer invalidate];
    self.downTimer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
