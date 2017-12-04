//
//  UIImageView+Browser.m
//  MasterKA
//
//  Created by jinghao on 16/6/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UIImageView+Browser.h"

@implementation UIImageView (Browser)

static char kcanBrowserKey;
static char kbrowserImagesKey;

- (BOOL)canBrowser
{
    NSNumber *can = objc_getAssociatedObject(self, &kcanBrowserKey);
    return can.boolValue;
}

- (void)setCanBrowser:(BOOL)canBrowser
{
    objc_setAssociatedObject(self, &kcanBrowserKey, [NSNumber numberWithBool:canBrowser], OBJC_ASSOCIATION_RETAIN);
    if (canBrowser) {
        __weak typeof(self) weakself = self;
        [self setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakself showImageBorwser];
        }];
    }else{
        [self setTapActionWithBlock:nil];
    }
}


- (void)setBrowserImages:(NSArray *)browserImages
{
    objc_setAssociatedObject(self, &kbrowserImagesKey, browserImages, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray*)browserImages
{
    return objc_getAssociatedObject(self, &kbrowserImagesKey);
}

- (void)showImageBorwser{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;

//    NSString *curUrl = [self.sd_imageURL absoluteString];
    NSInteger index = 0 ;
    
    for (int i=0; i<self.browserImages.count; i++) {
//        if ([curUrl hasSuffix:self.browserImages[i]]) {
//            index=i;
//            break;
//        }
    }
    
//    index = [self.browserImages indexOfObject:curUrl];
//    if (index==NSNotFound) {
//        index = 0;
//    }
    [browser setCurrentPhotoIndex:index];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.superViewController presentViewController:nc animated:YES completion:nil];
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.browserImages.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.browserImages.count){
        NSString *url =self.browserImages[index];
        url = [url masterFullImageUrl];
        url = [url stringByReplacingOccurrencesOfString:@"_thumb." withString:@"."];
       MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.browserImages.count){
        NSString *url =self.browserImages[index];
        url = [url masterFullImageUrl];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        return photo;
    }
    return nil;
}

@end
