//
//  ElementView.h
//  iOS通用基础框架
//
//  Created by 张欣欣 on 2017/5/27.
//  Copyright © 2017年 东方国信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElementView : UIView

@property (nonatomic, strong) NSString *Viewtype;

- (NSMutableArray *)setElementIndexWithIndex:(NSInteger )index;
@end
