//
//  QYSectionHeaderView.m
//  02-QQ好友
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYSectionHeaderView.h"
#import "QYFriendGroup.h"
@interface QYSectionHeaderView ()
@property (nonatomic, strong)UIButton *bgBtn;
@property (nonatomic, strong)UILabel *onlineLabel;
@end

@implementation QYSectionHeaderView

static NSString *headerViewIdentify = @"headerIdentify";


+(instancetype)headerViewWithTableView:(UITableView *)tableView
{
    //cell的重用机制
    QYSectionHeaderView *headerView = [tableView dequeueReusableCellWithIdentifier:headerViewIdentify];
    if (headerView == nil) {
        headerView = [[QYSectionHeaderView alloc] initWithReuseIdentifier:headerViewIdentify];
    }
    return headerView;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //自定义的控件
        //1、添加背景Btn
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:bgBtn];
        
        
        UIImage *image = [UIImage imageNamed:@"buddy_header_bg"];
        UIImage *bgImage  = [image resizableImageWithCapInsets:UIEdgeInsetsMake(44, 1, 44, 0) resizingMode:UIImageResizingModeStretch];
        
        UIImage *highlightedImage = [UIImage imageNamed:@"buddy_header_bg_highlighted"];
        UIImage *highlightedBGImage = [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(44, 1, 44, 0) resizingMode:UIImageResizingModeStretch];
        
        //设置背景图片
        [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [bgBtn setBackgroundImage:highlightedBGImage forState:UIControlStateHighlighted];
        
        [bgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置内容居左显示
        bgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //设置内容的偏移量
        bgBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
//        设置标题的偏移量
        bgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        //设置btn中图片视图的内容模式
        bgBtn.imageView.contentMode = UIViewContentModeCenter;
//
        bgBtn.imageView.clipsToBounds = NO;
        
        //添加左边的三角图片
        
        [bgBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //2、在背景Btn上添加右边的label
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentRight;
        
        _bgBtn = bgBtn;
        _onlineLabel = label;
        
    }
    return self;
}

//重新设置子视图的大小和位置
-(void)layoutSubviews
{
    [super layoutSubviews];
//    frame:相对于父视图的位置，bounds：相对于自身的位置，以自身为坐标系
    _bgBtn.frame = self.bounds;
    
    CGFloat labelW = 100;
    CGFloat labelH = self.bounds.size.height;
    CGFloat labelX = self.bounds.size.width - labelW - 10;
    CGFloat labelY = 0;
    _onlineLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

//对属性group重写set方法；
-(void)setGroup:(QYFriendGroup *)group
{
    _group = group;
    
    [_bgBtn setTitle:group.name forState:UIControlStateNormal];
    _onlineLabel.text = [NSString stringWithFormat:@"%d/%lu",group.online,(unsigned long)group.friends.count];
}

//sectionHeaderView的点击
-(void)bgBtnClick:(UIButton *)btn
{
//    本来打开和关闭是要视图控制器实现，而现在要HeaderView实现，所以要
//    block块、协议、通知中心、等方法实现，此处用了block块
    
    if (_group.isOpen) {
         _group.isOpen = NO;
    }else{
         _group.isOpen = YES;
    }
    
//   block做的事情 reloadData
//    if (_headerViewClick) {
//        _headerViewClick();
//    }
    
//    通知中心
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    
}

-(void)didMoveToSuperview
{
    if (_group.isOpen) {
        _bgBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        _bgBtn.imageView.transform = CGAffineTransformIdentity;
    }
}

@end
