//
//  ViewController.m
//  02-QQ好友
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYFriendGroup.h"
#import "QYFriend.h"
#import "QYSectionHeaderView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//由于通知中心更新数据的时候用到tableView属性，所以要关联一下
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//groups 对应于plist中的顶层数组array
@property (nonatomic, strong)NSArray *groups;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//、通知中心、
-(void)viewWillAppear:(BOOL)animated
{
//    UINavigationController
//    UINavigationBar
//    UINavigationControllerOperation
//    UINavigationItem
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reloadData" object:nil];
}
//移除监听
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
}

-(void)reload
{
    [self.tableView reloadData];
}

//懒加载
-(NSArray *)groups
{
    if (_groups == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *xuecheng = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            QYFriendGroup *friendGroup = [QYFriendGroup friendGroupWithDictionary:dic];
            [xuecheng addObject:friendGroup];
        }
        _groups = xuecheng;
    }
    return _groups;
}

#pragma mark - UITableView DataSource

//有多少组，
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    使用懒加载后，此处不不能用_groups.count;只能用self.groups.count;
    return self.groups.count;
}

//遵循上边的两个协议后，必须要实现的方法（一）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QYFriendGroup *fGroup = self.groups[section];
    if (fGroup.isOpen) {
        return fGroup.friends.count;
    }
    return 0;
}
//遵循上边的两个协议后，必须要实现的方法（二）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    //取出当前section对应的数据模型
    QYFriendGroup *friendGroup = (QYFriendGroup *)self.groups[indexPath.section];
    
    QYFriend *zhanglei = friendGroup.friends[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:zhanglei.icon];
    cell.textLabel.text = zhanglei.name;
    cell.detailTextLabel.text = zhanglei.status;
    cell.textLabel.textColor = zhanglei.vip ? [UIColor redColor] : [UIColor blackColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QYSectionHeaderView *sectionHeaderView = [QYSectionHeaderView headerViewWithTableView:tableView];

    QYFriendGroup *friendGroup = (QYFriendGroup *)self.groups[section];
    sectionHeaderView.group = friendGroup;
//    sectionHeaderView.headerViewClick = ^(){
//        [tableView reloadData];
//    };
    return sectionHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
