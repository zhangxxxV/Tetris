//
//  ElementView.m
//  iOS通用基础框架
//
//  Created by 张欣欣 on 2017/5/27.
//  Copyright © 2017年 东方国信. All rights reserved.
//

#import "ElementView.h"

#define Kelement_COLOR [UIColor colorWithWhite:0.3 alpha:0.7].CGColor

@interface ElementView ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ElementView

- (instancetype)init{
    self = [super init];
    if (self) {
        
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
- (NSMutableArray *)setElementIndexWithIndex:(NSInteger )index{
    NSMutableArray *arrM = [NSMutableArray array];
    switch (index) {
        case 0:
        {
            for (int i = 0; i<4; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(Kelement_W, i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@195,@205,@215,@225];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            
        }
            break;
        case 1:
        {
            for (int i = 0; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(0, i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = CGRectMake(Kelement_W, Kelement_W*2, Kelement_W, Kelement_W);
            layer.backgroundColor = Kelement_COLOR;
            [self.layer addSublayer:layer];
            NSArray *arr = @[@204,@214,@224,@205];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        case 2:
        {
            for (int i = 0; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(Kelement_W, i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = CGRectMake(0, Kelement_W*2, Kelement_W, Kelement_W);
            layer.backgroundColor = Kelement_COLOR;
            [self.layer addSublayer:layer];
            NSArray *arr = @[@205,@215,@225,@204];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        case 3:
        {
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = CGRectMake(Kelement_W, 0, Kelement_W, Kelement_W);
            layer.backgroundColor = Kelement_COLOR;
            [self.layer addSublayer:layer];
            for (int i = 0; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(i*Kelement_W,Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@214,@215,@216,@225];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        case 4:
        {
            for (int i = 0; i<4; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(i%2*Kelement_W,i/2*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@214,@215,@224,@225];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*2-1;
            self.height = Kelement_W*2-1;
        }
            break;
        case 5:
        {
            for (int i = 0; i<2; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(Kelement_W,i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
             }
            for (int i = 1; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(0,i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@204,@225,@214,@215];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        case 6:
        {
            for (int i = 0; i<2; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(0,i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            for (int i = 1; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(Kelement_W,i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@205,@215,@224,@214];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        case 7:
        {
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = CGRectMake(0, Kelement_W, Kelement_W, Kelement_W);
            layer.backgroundColor = Kelement_COLOR;
            [self.layer addSublayer:layer];
            CALayer *layer1 = [[CALayer alloc]init];
            layer1.frame = CGRectMake(Kelement_W*2, Kelement_W, Kelement_W, Kelement_W);
            layer1.backgroundColor = Kelement_COLOR;
            [self.layer addSublayer:layer1];
            for (int i = 0; i<3; i++) {
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(Kelement_W,i*Kelement_W, Kelement_W, Kelement_W);
                layer.backgroundColor = Kelement_COLOR;
                [self.layer addSublayer:layer];
            }
            NSArray *arr = @[@205,@225,@215,@214,@216];
            [arrM addObjectsFromArray:arr];
            self.width = Kelement_W*3-1;
            self.height = Kelement_W*3-1;
        }
            break;
        default:
            break;
    }
    return arrM;
}
//- (void)setImgViewWithImage:(NSString *)str{
//    if (self.imgView == nil) {
//        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
//        self.imgView.bounds = self.bounds;
//        [self addSubview:self.imgView];
//    }
//    self.imgView.image = [UIImage imageNamed:str];
//}
//- (void)drawRect:(CGRect)rect {
//    NSLog(@"%@",self.Viewtype);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIColor *aColor = [UIColor redColor];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextSetGrayStrokeColor(context, 1, 1);
//    CGContextSetLineWidth(context, 1.0);
//    if ([self.Viewtype isEqualToString:@"01"]) {
//        CGContextMoveToPoint(context, 0, 0);
//        CGContextAddLineToPoint(context, 0, 80);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 20, 0);
//        CGContextAddLineToPoint(context, 0, 0);
//    }else if ([self.Viewtype isEqualToString:@"02"]){
//        CGContextMoveToPoint(context, 0, 20);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 80);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 20, 20);
//        CGContextAddLineToPoint(context, 0, 20);
//    }else if ([self.Viewtype isEqualToString:@"03"]){
//        CGContextMoveToPoint(context, 0, 40);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 80);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 20, 40);
//        CGContextAddLineToPoint(context, 0, 40);
//    }else if ([self.Viewtype isEqualToString:@"04"]){
//        CGContextMoveToPoint(context, 0, 80);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 40);
//        CGContextAddLineToPoint(context, 20, 40);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 0, 80);
//    }else if ([self.Viewtype isEqualToString:@"05"]){
//        CGContextMoveToPoint(context, 0, 80);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 60, 100);
//        CGContextAddLineToPoint(context, 60, 80);
//        CGContextAddLineToPoint(context, 40, 80);
//        CGContextAddLineToPoint(context, 40, 60);
//        CGContextAddLineToPoint(context, 20, 60);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 0, 80);
//    }else if ([self.Viewtype isEqualToString:@"06"]){
//        CGContextMoveToPoint(context, 0, 60);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 60);
//        CGContextAddLineToPoint(context, 0, 60);
//    }else if ([self.Viewtype isEqualToString:@"07"]){
//        CGContextMoveToPoint(context, 0, 60);
//        CGContextAddLineToPoint(context, 0, 100);
//        CGContextAddLineToPoint(context, 20, 100);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 40, 80);
//        CGContextAddLineToPoint(context, 40, 40);
//        CGContextAddLineToPoint(context, 20, 40);
//        CGContextAddLineToPoint(context, 20, 60);
//        CGContextAddLineToPoint(context, 0, 60);
//    }else if ([self.Viewtype isEqualToString:@"08"]){
//        CGContextMoveToPoint(context, 0, 40);
//        CGContextAddLineToPoint(context, 0, 80);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 20, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 60);
//        CGContextAddLineToPoint(context, 20, 60);
//        CGContextAddLineToPoint(context, 20, 40);
//        CGContextAddLineToPoint(context, 0, 40);
//    }else if ([self.Viewtype isEqualToString:@"09"]){
//        CGContextMoveToPoint(context, 0, 60);
//        CGContextAddLineToPoint(context, 0, 80);
//        CGContextAddLineToPoint(context, 20, 80);
//        CGContextAddLineToPoint(context, 20, 100);
//        CGContextAddLineToPoint(context, 40, 100);
//        CGContextAddLineToPoint(context, 40, 80);
//        CGContextAddLineToPoint(context, 60, 80);
//        CGContextAddLineToPoint(context, 60, 60);
//        CGContextAddLineToPoint(context, 40, 60);
//        CGContextAddLineToPoint(context, 40, 40);
//        CGContextAddLineToPoint(context, 20, 40);
//        CGContextAddLineToPoint(context, 20, 60);
//        CGContextAddLineToPoint(context, 0, 60);
//    }
//    
//    CGContextDrawPath(context, kCGPathFillStroke);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
