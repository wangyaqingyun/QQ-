//
//  QYFriend.m
//  02-QQ好友
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYFriend.h"

@implementation QYFriend
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
//   self = [super init]， 初始化是为了用父类的属性，不初始化，就不能调用父类的方法
    if (self = [super init]) {
        //拿字典数据灌入模型
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)friendWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}
@end
