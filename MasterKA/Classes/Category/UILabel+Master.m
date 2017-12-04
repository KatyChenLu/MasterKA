//
//  UILabel+Master.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/9.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "UILabel+Master.h"
#import <objc/runtime.h>
//#import "AttributedStyleAction.h"
#import <CoreText/CoreText.h>
#import "FaceUtil.h"

@implementation UILabel (Master)

+ (void)initialize
{
    // 获取到UILabel中setText对应的method
    Method setText = class_getInstanceMethod([UILabel class], @selector(setText:));
    Method setTextMySelf = class_getInstanceMethod([self class], @selector(setTextHooked:));
    
    // 将目标函数的原实现绑定到setTextOriginalImplemention方法上
    IMP setTextImp = method_getImplementation(setText);
    class_addMethod([UILabel class], @selector(setTextOriginal:), setTextImp, method_getTypeEncoding(setText));
    
    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP setTextMySelfImp = method_getImplementation(setTextMySelf);
    class_replaceMethod([UILabel class], @selector(setText:), setTextMySelfImp, method_getTypeEncoding(setText));
}

- (void)setCanCopy:(BOOL)canCopy
{
    objc_setAssociatedObject(self, @selector(canCopy), [NSNumber numberWithBool:canCopy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (canCopy) {
        __weak __typeof(self)weakSelf = self;
        [self setLongPressActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {        __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showMenuController];
        }];
    }else{
        [self setLongPressActionWithBlock:nil];
    }
}

- (BOOL)canCopy{
    NSNumber * copyNum = objc_getAssociatedObject(self, @selector(canCopy));
    if (copyNum && [copyNum boolValue]) {
        YES;
    }
    return NO;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)setParagraphText:(NSString*)text{
    if(text == nil || text.length == 0){
        text = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attributedString;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(copy:));
}

- (void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

- (void)showMenuController{
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                      action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

- (void)setTextHooked:(NSString *)string
{
        //在这里插入过滤算法
    if (string==nil) {
        string=@"";
    }else if ([string isKindOfClass:[NSNull class]]) {
        string  = @"";
    }else if(string==NULL){
        string  = @"";
    }else if(![string isKindOfClass:[NSString class]]){
        string = [NSString stringWithFormat:@"%@",string];
    }
    [self performSelector:@selector(setTextOriginal:) withObject:string];
}


- (void)setEmojiText:(NSString *)text{
    [self setEmojiText:text attributes:nil];
}

- (void)setEmojiText:(NSString *)text attributes:(NSDictionary *)attrs{
    self.attributedText = [NSAttributedString  emotionAttributedStringFrom:text attributes:attrs];
}

- (void)checkPhoneAndLink{
    self.userInteractionEnabled = TRUE;
    NSLog(@"getRangesForPhoneNumbers %@",[self getRangesForPhoneNumbers:self.text]);
    
    
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor blueColor]
                                 };
    for (id linkData in [self getRangesForPhoneNumbers:self.text]) {
        NSRange matchRange = [[linkData objectForKey:@"range"] rangeValue];;
        [mutableAttributeString addAttributes:attributes range:matchRange];
    }
    self.attributedText = mutableAttributeString;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkOnClick:)];
    [self addGestureRecognizer:tap];
}

- (void)linkOnClick:(UITapGestureRecognizer*)sender{
    CGPoint potin = [sender locationInView:self];
    NSLog(@"======= %f   %f %@",potin.x,potin.y,[self textAttributesAtPoint:potin]);
}

/*
 * 所有电话号码
 */
- (NSArray *)getRangesForPhoneNumbers:(NSString *)text
{
    NSMutableArray *rangesForPhoneNumbers = [[NSMutableArray alloc] init];;
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSArray *matches = [detector matchesInString:text
                                         options:0
                                           range:NSMakeRange(0, text.length)];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match range];
        NSString *matchString = [text substringWithRange:matchRange];
        
        if ([match resultType] == NSTextCheckingTypePhoneNumber){
            [rangesForPhoneNumbers addObject:@{
                                               @"linkType" : @"phoneType",
                                               @"range"    : [NSValue valueWithRange:matchRange],
                                               @"link"     : matchString
                                               }];
        }
    }
    return rangesForPhoneNumbers;
}

//////////////废弃//////////////////////

-(void)tapped:(UITapGestureRecognizer*)gesture
{
    
    
}

-(void)addHotspotHandler
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
    
    
}

-(NSDictionary*)textAttributesAtPointOld:(CGPoint)pt{
    NSDictionary* dictionary = nil;
    NSArray*  rangeArray = [self getRangesForPhoneNumbers:self.text];
    // First, create a CoreText framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get each of the typeset lines
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    CGPoint origins[CFArrayGetCount(lines)];
    //获取每行的原点坐标
    
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    CTLineRef line = NULL;
    
    CGPoint lineOrigin = CGPointZero;
    
    for (int i= 0; i < CFArrayGetCount(lines); i++)
        
    {
        
        CGPoint origin = origins[i];
        
        CGPathRef path = CTFrameGetPath(frameRef);
        
        //获取整个CTFrame的大小
        
        CGRect rect = CGPathGetBoundingBox(path);
        
        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
        
        NSLog(@"rect:%@",NSStringFromCGRect(rect));
        
        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
        
        NSLog(@"y:%f",y);
        
        //判断点击的位置处于那一行范围内
        
        if ((pt.y <= y) && (pt.x >= origin.x))
            
        {
            
            line = CFArrayGetValueAtIndex(lines, i);
            
            lineOrigin = origin;
            
            break;
            
        }
        
    }
    
    
    
    pt.x -= lineOrigin.x;
    
    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
    
    CFIndex index = CTLineGetStringIndexForPosition(line, pt);
    
    NSLog(@"index:%ld",index);
    
    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
    for (id linkData in rangeArray) {
        NSRange matchRange = [[linkData objectForKey:@"range"] rangeValue];;
        if (index>=matchRange.location&& index<matchRange.location+matchRange.length)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"click event" message:[linkData objectForKey:@"link"] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
            
            [alert show];
        }
    }
    return dictionary;
}

-(NSDictionary*)textAttributesAtPoint:(CGPoint)pt
{
    // Locate the attributes of the text within the label at the specified point
    NSDictionary* dictionary = nil;
    
    // First, create a CoreText framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get each of the typeset lines
    NSArray *lines = (__bridge id)CTFrameGetLines(frameRef);
    
    CFIndex linesCount = [lines count];
    CGPoint *lineOrigins = (CGPoint *) malloc(sizeof(CGPoint) * linesCount);
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, linesCount), lineOrigins);
    
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    // Correct each of the typeset lines (which have origin (0,0)) to the correct orientation (typesetting offsets from the bottom of the frame)
    
    CGFloat bottom = self.frame.size.height;
    for(CFIndex i = 0; i < linesCount; ++i) {
        lineOrigins[i].y = self.frame.size.height - lineOrigins[i].y;
        bottom = lineOrigins[i].y;
    }
    
    // Offset the touch point by the amount of space between the top of the label frame and the text
    pt.y -= (self.frame.size.height - bottom)/2;
    
    NSArray*  rangeArray = [self getRangesForPhoneNumbers:self.text];

    // Scan through each line to find the line containing the touch point y position
    float lastY =0;
    for(CFIndex i = 0; i < linesCount; ++i) {
        line = (__bridge CTLineRef)[lines objectAtIndex:i];
        lineOrigin = lineOrigins[i];
        CGFloat descent, ascent;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, nil);
        NSLog(@"=== %f  descent %f lineOrigin.y %f == %f",pt.y ,descent,lineOrigin.y,(floor(lineOrigin.y) + floor(descent)));
//        descent +=10;
        if(pt.y < (floor(lineOrigin.y) + floor(descent))) {
            
            // Cater for text alignment set in the label itself (not in the attributed string)
            if (self.textAlignment == NSTextAlignmentCenter) {
                pt.x -= (self.frame.size.width - width)/2;
            } else if (self.textAlignment == NSTextAlignmentRight) {
                pt.x -= (self.frame.size.width - width);
            }
            
            // Offset the touch position by the actual typeset line origin. pt is now the correct touch position with the line bounds
            pt.x -= lineOrigin.x;
            pt.y -= lineOrigin.y;
            
            // Find the text index within this line for the touch position
            CFIndex i = CTLineGetStringIndexForPosition(line, pt);
            
            // Iterate through each of the glyph runs to find the run containing the character index
            
//            for (id linkData in rangeArray) {
//                NSRange matchRange = [[linkData objectForKey:@"range"] rangeValue];;
//                if (i>=matchRange.location&& i<matchRange.location+matchRange.length)
//                {
//                    dictionary = linkData;
//                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"click event" message:[linkData objectForKey:@"link"] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//                    
//                    [alert show];
//                    break;
//                }
//            }
            
            NSArray* glyphRuns = (__bridge id)CTLineGetGlyphRuns(line);
            CFIndex runCount = [glyphRuns count];
            for (CFIndex run=0; run<runCount; run++) {
                CTRunRef glyphRun = (__bridge CTRunRef)[glyphRuns objectAtIndex:run];
                CFRange range = CTRunGetStringRange(glyphRun);
                if (i >= range.location && i<= range.location+range.length) {
                    dictionary = (__bridge NSDictionary*)CTRunGetAttributes(glyphRun);
                    break;
                }
            }
            if (dictionary) {
                break;
            }
        }
    }
    
    free(lineOrigins);
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    
    return dictionary;
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

@end
