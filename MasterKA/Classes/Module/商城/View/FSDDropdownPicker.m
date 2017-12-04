//
//  FSDDropdownPicker.m
//  HiGoMaster
//
//  Created by jinghao on 15/6/14.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "FSDDropdownPicker.h"


@interface FSDDropdownPicker () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGRect originalFrame;
@property (assign, nonatomic) CGRect tableFrame;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIVisualEffectView *bluredEffectView;
@property (strong, nonatomic) UIView *tapOutView;
@property (strong, nonatomic) UIButton *actionButton;

@end

@implementation FSDDropdownPicker


- (instancetype)initWithOptions:(NSArray *)options {
    //    UIImage *buttonImage = [UIImage imageNamed:@"icon_calendar"];
    //    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.actionButton setImage:buttonImage forState:UIControlStateNormal];
    //    self.actionButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    //    if(self = [super initWithCustomView:self.actionButton]){
    //        [self.actionButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside;
    id <FSDPickerItemProtocol> firstItem = [options firstObject];
//    UIImage *buttonImage = [firstItem image];
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [actionButton setTitle:[firstItem name] forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [actionButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [actionButton setImage:[UIImage imageNamed:@"jiantouxia"] forState:UIControlStateNormal];
    [actionButton sizeToFit];
//    [actionButton rightImage];
    
    
//    actionButton.frame = CGRectMake(0.0, 0.0, 44, 44); //buttonImage.size.width, buttonImage.size.height);
    
    
    if (self = [super initWithCustomView:actionButton]) {
        [actionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        self.actionButton = actionButton;
        
        self.options = options;
        _isDropped = NO;
        
        for (id <FSDPickerItemProtocol> item   in self.options) {
            if (item.selected) {
                self.selectedOption = item;
            }
        }
        if(self.selectedOption==nil){
            self.selectedOption = [options firstObject];
        }
        
        self.displaysImageInList = NO;
        
        self.tapOutView = nil;
        
        self.rowHeight = 44.0f;
        
        self.listSeparator = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (UINavigationBar *)navigationBar {
    return (UINavigationBar *)[self.customView superview];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect navFrame = [self navigationBar].frame;
        self.tableFrame = CGRectMake(CGRectGetMinX(navFrame), CGRectGetMaxY(navFrame), CGRectGetWidth(navFrame), self.options.count * self.rowHeight+44);
        
        _tableView = [[UITableView alloc] initWithFrame:self.tableFrame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = YES;
        _tableView.scrollEnabled = NO;
//        _tableView.separatorStyle = self.listSeparator;
        _tableView.rowHeight = self.rowHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        
//        [self hideDropdownAnimated:NO];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds];
        self.tableView.layer.masksToBounds = NO;
        self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.tableView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        self.tableView.layer.cornerRadius = 2.0f;
        self.tableView.layer.shadowOpacity = 0.3f;
        self.tableView.layer.shadowPath = shadowPath.CGPath;
        
        
        NSInteger row=0;
        for (id <FSDPickerItemProtocol> item   in self.options) {
            if (item.selected) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] ];
                UILabel* textLabel = (UILabel*)[cell viewWithTag:100];
                textLabel.textColor = [UIColor colorWithHex:0x00a0e9];
                break;
            }
            row++;
        }

        
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
//        UILabel* textLabel = (UILabel*)[cell viewWithTag:100];
//        textLabel.textColor = [UIColor colorWithHex:0x00a0e9];
        
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    if (!_tableView.superview) {
        [[self navigationBar].superview insertSubview:_tableView belowSubview:[self navigationBar]];
    }
    return _tableView;
}

- (void)buttonTapped:(id)sender {
    [self toggleDropdown];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    _tableView.rowHeight = rowHeight;
    CGRect tableFrame = self.tableFrame;
    tableFrame.size.height = self.options.count * rowHeight;
    self.tableFrame = tableFrame;
    [_tableView reloadData];
}

- (void)setDisplaysImageInList:(BOOL)displaysImageInList {
    _displaysImageInList = displaysImageInList;
}

- (void)setListSeparator:(UITableViewCellSeparatorStyle)listSeparator {
    _listSeparator = listSeparator;
    _tableView.separatorStyle = listSeparator;
}

- (void)toggleDropdown {
    _isDropped = !_isDropped;
    if (self.isDropped) {
        [self showDropdownAnimated:YES];
    }
    else {
        [self hideDropdownAnimated:YES];
    }
}

- (void)showDropdownAnimated:(BOOL)animated {
    _isDropped = YES;
    [self.delegate dropdownPicker:self didDropDown:YES];
    
    self.tableView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = self.tableFrame;
                         }
         
                         completion: ^(BOOL finished) {
                         }];
    }
    else {
        self.tableView.frame = self.tableFrame;
        //        self.frame = self.originalFrame;
    }
    [self.tableView.superview insertSubview:self.tapOutView belowSubview:self.tableView];
}

- (void)hideDropdownAnimated:(BOOL)animated {
    _isDropped = NO;
    [self.delegate dropdownPicker:self didDropDown:NO];
    
    CGRect frame = self.tableFrame;
    frame.origin.y -= CGRectGetHeight(self.tableView.bounds) + 5;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = frame;
                         }
         
                         completion: ^(BOOL finished) {
                             self.tableView.hidden = YES;
                         }];
    }
    else {
        self.tableView.frame = frame;
        self.tableView.hidden = YES;
    }
    [self.tapOutView removeFromSuperview];
    self.tapOutView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count+1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dropCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:self.rowHeight / 2.3];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        
        UILabel* label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.tag = 100;
        [cell.contentView addSubview:label];
        NSMutableArray* array = [NSMutableArray array];
        [array addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [array addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [cell.contentView addConstraints:array];
        
    }
    UILabel* textLabel = (UILabel*)[cell viewWithTag:100];

    if (indexPath.row==(self.options.count-0)) {
        cell.userInteractionEnabled = NO;
        textLabel.text = @"更多城市，敬请期待";
        textLabel.textColor = [UIColor colorWithHex:0x999999];
        textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        cell.userInteractionEnabled = YES;
        id <FSDPickerItemProtocol> item = [self.options objectAtIndex:indexPath.row];
        textLabel.textColor = [UIColor colorWithHex:0x333333];
        
//        if (item == self.selectedOption) {
//            textLabel.textColor = [UIColor colorWithHex:0x00a0e9];
//            cell.selected = TRUE;
//        }
        
        
        textLabel.text = [item name];
        if (self.displaysImageInList) {
            cell.imageView.image = [item image];
            textLabel.textAlignment = NSTextAlignmentLeft;
        }
        else {
            textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
//        if (_selectedOption==item) {
//            textLabel.textColor = [UIColor colorWithHex:0x00a0e9];
//        }
    }
    
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedOption = [self.options objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* textLabel = (UILabel*)[cell viewWithTag:100];
    textLabel.textColor = [UIColor colorWithHex:0x00a0e9];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* textLabel = (UILabel*)[cell viewWithTag:100];
    textLabel.textColor = [UIColor colorWithHex:0x999999];
}

- (void)setSelectedOption:(id <FSDPickerItemProtocol> )selectedOption {
    _selectedOption = selectedOption;
//    [self.actionButton setImage:[_selectedOption image] forState:UIControlStateNormal];
    [self.actionButton setTitle:[_selectedOption name] forState:UIControlStateNormal];
//    [self.actionButton rightImage];
    if (self.delegate && [self.delegate dropdownPicker:self didSelectOption:_selectedOption]) {
        [self hideDropdownAnimated:YES];
    }
}

#pragma mark - Tapoutview
- (UIView *)tapOutView {
    if (!_tapOutView && self.tableView.window) {
        _tapOutView = [[UIView alloc] initWithFrame:self.tableView.window.rootViewController.view.frame];
        _tapOutView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutTapped:)];
        [_tapOutView addGestureRecognizer:tap];
    }
    return _tapOutView;
}

- (void)tapOutTapped:(id)sender {
    [self hideDropdownAnimated:YES];
}

@end
