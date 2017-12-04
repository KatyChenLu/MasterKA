//
//  StudentController.m
//  MasterKA
//
//  Created by hyu on 16/5/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "StudentController.h"
#import "CouseStudentCell.h"
@interface StudentController ()
@property (nonatomic ,strong) NSArray *studentArr;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@end

@implementation StudentController

- (void)viewDidLoad {
    [super viewDidLoad];
    _studentArr =self.params[@"students"];
//    [self.mTableView registerCellWithReuseIdentifier: @"CouseStudentCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  _studentArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CouseStudentCell *cell = [_mTableView dequeueReusableCellWithIdentifier:@"CouseStudentCell" forIndexPath:indexPath];
    NSDictionary *dic =_studentArr[indexPath.row];
//    [cell.img_top setImageWithURLString:dic[@"img_top"] placeholderImage:nil];
    static NSString *simpleIdentify = @"CouseStudentCell";
    CouseStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CouseStudentCell" owner:self options:nil];
    if ([nib count]>0)
    {
        cell = [nib objectAtIndex:0];
        
    }
    [cell.img_top setImageWithURLString:dic[@"img_top"] placeholderImage:nil];
       return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"个人主页");

}
@end
