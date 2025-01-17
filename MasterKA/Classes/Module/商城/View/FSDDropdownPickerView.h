//
//  FSDDropdownPickerView.h
//  MasterKA
//
//  Created by xmy on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "FSDPickerItemProtocol.h"

@protocol FSDDropdownPickerViewDelegate;

@interface FSDDropdownPickerView : UIView
@property (strong, nonatomic) UIButton *actionButton;
/**
 *  The delegate
 */
@property (weak, nonatomic) id <FSDDropdownPickerViewDelegate> delegate;

/**
 *  If the picker is currently dropped down or not
 */
@property (assign, nonatomic, readonly) BOOL isDropped;

/**
 *  The current selected option from the dropdown picker
 */
@property (strong, nonatomic) id <FSDPickerItemProtocol> selectedOption;

/**
 *  The height of each option in the dropdown picker
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 *  Whether to show images when the picker drops down or not
 */
@property (assign, nonatomic) BOOL displaysImageInList;


/**
 *  The list separator style for the picker items
 */
@property (assign, nonatomic) UITableViewCellSeparatorStyle listSeparator;

/**
 *  Initialize a FSDDropdownpicker instance given a list of items to display
 *
 *  @param options array containing id<FSDPickerItemProtocol> items to be displayed
 *
 *  @return FSDDropdownPicker instance
 */
- (instancetype)initWithOptions:(NSArray *)options;

/**
 *  Shows the dropdown list
 *
 *  @param animated
 */
- (void)showDropdownAnimated:(BOOL)animated;

/**
 *  Hides the dropdown list
 *
 *  @param animated
 */
- (void)hideDropdownAnimated:(BOOL)animated;


/**
 *  Togges the dropdown show/hide
 */
- (void)toggleDropdown;

- (void)setPaddingLeft:(CGFloat)left;

@end


@protocol FSDDropdownPickerViewDelegate <NSObject>

/**
 *  Called when the user selects an option from the dropdown
 *
 *  @param dropdownPicker the picker that received the event
 *  @param option         the selected option
 *
 *  @return whether the dropdown should dismiss or not
 */
- (BOOL)dropdownPickerView:(FSDDropdownPickerView *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option;
@optional


/**
 *  Called when the dropdown picker shows or dismisses
 *
 *  @param dropdownPicker the dropdown picker
 *  @param drop           YES if picker was shown, NO if it was hidden
 */
- (void)dropdownPickerView:(FSDDropdownPickerView *)dropdownPicker didDropDown:(BOOL)drop;



@end
