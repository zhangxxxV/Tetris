//
//  RussiaView.m
//  iOS通用基础框架
//
//  Created by 张欣欣 on 2017/5/25.
//  Copyright © 2017年 东方国信. All rights reserved.
//

#import "RussiaView.h"

@implementation RussiaView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // [self initialize];
    }
    return self;
}
-(void)initialize{
    for (int i = 0; i<200; i++) {
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = CGRectMake(i%10*Kelement_W, i/10*Kelement_W, Kelement_W, Kelement_W);
        layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        layer.borderWidth = 0.5;
        layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.5].CGColor;
        [self.layer addSublayer:layer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
