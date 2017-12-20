//
//  UINavigationItem+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/31.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UINavigationItem+Master.h"
#import <objc/runtime.h>


FOUNDATION_EXPORT double UINavigationItem_MarginVersionNumber;
FOUNDATION_EXPORT const unsigned char UINavigationItem_MarginVersionString[];

static NSString *kCustomBackButtonKey = @"kCustomBackButtonKey";
static NSString *kBackButtonTitleKey = @"kBackButtonTitleKey";

@implementation UINavigationItem (Master)


+ (void)load
{
    // left
    [self swizzle:@selector(leftBarButtonItem)];
    [self swizzle:@selector(setLeftBarButtonItem:animated:)];
    [self swizzle:@selector(leftBarButtonItems)];
    [self swizzle:@selector(setLeftBarButtonItems:animated:)];
    
    // right
    [self swizzle:@selector(rightBarButtonItem)];
    [self swizzle:@selector(setRightBarButtonItem:animated:)];
    [self swizzle:@selector(rightBarButtonItems)];
    [self swizzle:@selector(setRightBarButtonItems:animated:)];
//
    
//    // back
//    [self swizzle:@selector(backBarButtonItem)];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(swizzled_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
    
}

+ (void)swizzle:(SEL)selector
{
    NSString *name = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(selector)];
    
    Method m1 = class_getInstanceMethod(self, selector);
    Method m2 = class_getInstanceMethod(self, NSSelectorFromString(name));
    
    method_exchangeImplementations(m1, m2);
}

#pragma mark -- backBarButtonItem

-(UIBarButtonItem *)swizzled_backBarbuttonItem{
    UIBarButtonItem *item = [self swizzled_backBarbuttonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:self.backTitle style:UIBarButtonItemStyleBordered target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)setBackTitle:(NSString *)backTitle
{
    objc_setAssociatedObject(self, @selector(backTitle), backTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)backTitle{
    return objc_getAssociatedObject(self, @selector(backTitle));
}

#pragma mark - Global

+ (CGFloat)systemMargin
{
    return -10; // iOS 7+
}

#pragma mark - Margin

- (CGFloat)leftMargin
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(leftMargin));
    return value ? value.floatValue : [self.class systemMargin];
}

- (void)setLeftMargin:(CGFloat)leftMargin
{
    objc_setAssociatedObject(self, @selector(leftMargin), @(leftMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.leftBarButtonItems = self.leftBarButtonItems;
}

- (CGFloat)rightMargin
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(rightMargin));
    return value ? value.floatValue : [self.class systemMargin];
}

- (void)setRightMargin:(CGFloat)rightMargin
{
    objc_setAssociatedObject(self, @selector(rightMargin), @(rightMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.rightBarButtonItems = self.rightBarButtonItems;
}

#pragma mark - Spacer

- (UIBarButtonItem *)spacerForItem:(UIBarButtonItem *)item withMargin:(CGFloat)margin
{
    UIBarButtonSystemItem type = UIBarButtonSystemItemFixedSpace;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:nil];
    spacer.width = margin - [self.class systemMargin];
    if (!item.customView) {
        spacer.width += 20; // a margin of private class `UINavigationButton` is different from custom view
    }
    return spacer;
}

- (UIBarButtonItem *)leftSpacerForItem:(UIBarButtonItem *)item
{
//    return [self spacerForItem:item withMargin:-20];
    return [self spacerForItem:item withMargin:self.leftMargin];
}

- (UIBarButtonItem *)rightSpacerForItem:(UIBarButtonItem *)item
{
  
//    return [self spacerForItem:item withMargin:-20];
    return [self spacerForItem:item withMargin:self.rightMargin];
}

#pragma mark - Original Bar Button Items

- (NSArray *)originalLeftBarButtonItems
{
    return objc_getAssociatedObject(self, @selector(originalLeftBarButtonItems));
}

- (void)setOriginalLeftBarButtonItems:(NSArray *)items
{
    objc_setAssociatedObject(self, @selector(originalLeftBarButtonItems), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)originalRightBarButtonItems
{
    return objc_getAssociatedObject(self, @selector(originalRightBarButtonItems));
}

- (void)setOriginalRightBarButtonItems:(NSArray *)items
{
    objc_setAssociatedObject(self, @selector(originalRightBarButtonItems), items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Bar Button Item

- (UIBarButtonItem *)swizzled_leftBarButtonItem
{
    return self.originalLeftBarButtonItems.firstObject;
}

- (void)swizzled_setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if (!item) {
        [self setLeftBarButtonItems:nil animated:animated];
    } else {
        [self setLeftBarButtonItems:@[item] animated:animated];
    }
}

- (UIBarButtonItem *)swizzled_rightBarButtonItem
{
    return self.originalRightBarButtonItems.firstObject;
}

- (void)swizzled_setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if (!item) {
        [self setRightBarButtonItems:nil animated:animated];
    } else {
        [self setRightBarButtonItems:@[item] animated:animated];
    }
}


#pragma mark - Bar Button Items

- (NSArray *)swizzled_leftBarButtonItems
{
    return self.originalLeftBarButtonItems;
}

- (void)swizzled_setLeftBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    if (items.count) {
        self.originalLeftBarButtonItems = items;
        UIBarButtonItem *spacer = [self leftSpacerForItem:items.firstObject];
        NSArray *itemsWithMargin = [@[spacer] arrayByAddingObjectsFromArray:items];
        [self swizzled_setLeftBarButtonItems:itemsWithMargin animated:animated];
    } else {
        self.originalLeftBarButtonItems = nil;
        [self swizzled_setLeftBarButtonItem:nil animated:animated];
    }
}

- (NSArray *)swizzled_rightBarButtonItems
{
    return self.originalRightBarButtonItems;
}

- (void)swizzled_setRightBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    if (items.count) {
        self.originalRightBarButtonItems = items;
        UIBarButtonItem *spacer = [self rightSpacerForItem:items.firstObject];
        NSArray *itemsWithMargin = [@[spacer] arrayByAddingObjectsFromArray:items];
        [self swizzled_setRightBarButtonItems:itemsWithMargin animated:animated];
    } else {
        self.originalRightBarButtonItems = nil;
        [self swizzled_setRightBarButtonItem:nil animated:animated];
    }
}

#pragma mark -- lock
- (void)lockRightItem:(BOOL)lock
{
    NSArray *rightBarItems = self.rightBarButtonItems;
    if (rightBarItems  && [rightBarItems count]>0) {
        [rightBarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIBarButtonItem class]] ||
                [obj isMemberOfClass:[UIBarButtonItem class]])
            {
                UIBarButtonItem *barButtonItem = (UIBarButtonItem *)obj;
                barButtonItem.enabled = !lock;
            }
        }];
    }
}

- (void)lockLeftItem:(BOOL)lock
{
    NSArray *leftBarItems = self.leftBarButtonItems;
    if (leftBarItems  && [leftBarItems count]>0) {
        [leftBarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIBarButtonItem class]] ||
                [obj isMemberOfClass:[UIBarButtonItem class]])
            {
                UIBarButtonItem *barButtonItem = (UIBarButtonItem *)obj;
                barButtonItem.enabled = !lock;
            }
        }];
    }
}

#pragma mark -- 添加


- (void)addLeftBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated{
    
    NSMutableArray *itemArray = [NSMutableArray array];
    if (self.leftBarButtonItems && self.leftBarButtonItems.count>0) {
        [itemArray addObjectsFromArray:self.leftBarButtonItems];
    }
    [itemArray addObject:item];
    [self setLeftBarButtonItems:itemArray animated:animated];
}
- (void)addRightBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated{
   
    
    NSMutableArray *itemArray = [NSMutableArray array];
    if (self.rightBarButtonItems) {
        [itemArray addObjectsFromArray:self.rightBarButtonItems];
    }
    
    [itemArray addObject:item];
    [self setRightBarButtonItems:itemArray animated:animated];
}

- (void)removeRightBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated
{
    NSMutableArray *itemArray = [NSMutableArray array];
    if (self.rightBarButtonItems) {
        [itemArray addObjectsFromArray:self.rightBarButtonItems];
    }
    [itemArray removeObject:item];
    [self setRightBarButtonItems:itemArray animated:animated];

}
@end
