//
//  UITextView+Master.m
//  HiGoMaster
//
//  Created by jinghao on 15/4/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "UITextView+Master.h"
#import "FaceUtil.h"
#import <objc/runtime.h>

@implementation UITextView (Master)

+ (void)load {
    [super load];
    
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (label) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}
#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}


#pragma mark - Properties
#pragma mark `placeholderLabel`

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        
        label = [[UILabel alloc] init];
        label.textColor = [self.class defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}


#pragma mark `placeholder`

- (NSString *)placeholderStr {
    return self.placeholderLabel.text;
}

- (void)setPlaceholderStr:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self updatePlaceholderLabel];
}

#pragma mark `placeholderColor`

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self updatePlaceholderLabel];
}


#pragma mark - Update

- (void)updatePlaceholderLabel {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    [self insertSubview:self.placeholderLabel atIndex:0];
    
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;
    
    // `NSTextContainer` is available since iOS 7
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;
    
#pragma deploymate push "ignored-api-availability"
    // iOS 7+
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        lineFragmentPadding = self.textContainer.lineFragmentPadding;
        textContainerInset = self.textContainerInset;
    }
#pragma deploymate pop
    
    // iOS 6
    else {
        lineFragmentPadding = 5;
        textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

- (void)checkAttachment{
    NSMutableDictionary* typingAttributes = [NSMutableDictionary dictionaryWithDictionary:self.typingAttributes];
    for(id key in self.typingAttributes.allKeys)
    {
        id value =self.typingAttributes[@"NSAttachment"];
        NSString* className = NSStringFromClass([value class]);
        if ([className isEqualToString:@"EmojiTextAttachment"]) {
            [typingAttributes removeObjectForKey:key];
        }
    }
    self.typingAttributes= typingAttributes;
}

- (BOOL)deleteEmojiValue{
    BOOL deleteResult = FALSE ;
//    if (self.selectedRange.location == self.text.length && self.text.length>0) {
//        NSString * regexStr = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//        NSError* error;
//        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
//        if (regex !=nil && self.selectedRange.location) {
//            NSString* string = [self.text substringToIndex:self.selectedRange.location];
//            NSString* toString = nil;
//            if (self.selectedRange.location<self.text.length) {
//                toString = [self.text substringFromIndex:self.selectedRange.location];
//            }
//            NSArray* emjoiArray = [regex matchesInString:self.text options:0 range:NSMakeRange(0, string.length)];
//            if (emjoiArray.count>0) {
//                NSDictionary* faceDict = [FaceUtil getFaceDictionary];
//                NSTextCheckingResult *match = [emjoiArray lastObject];
//                NSRange range = [match range];
//                if ((range.length+range.location)==string.length) {
//                    NSString *subStr = [string substringWithRange:[match range]];
//                    NSUInteger index = [faceDict.allValues indexOfObject:subStr];
//                    if (index != NSNotFound) {
//                        self.text = [string substringToIndex:range.location];
//                        deleteResult = TRUE;
//                        self.selectedRange =NSMakeRange(self.text.length, self.selectedRange.length);
//                    }
//                }
//            }
//            if (deleteResult && toString) {
//                self.text = [NSString stringWithFormat:@"%@%@",self.text,toString];
//            }
//        }
//    }
    [self performSelector:@selector(deleteBackward) withObject:nil];
    deleteResult = TRUE;
    return deleteResult;
}
- (NSString*)emojiText{
    if (self.textStorage && self.textStorage.length>0) {
        return [self.textStorage getPlainString];
    }else {
        return self.text;
    }
}
- (void)addEmojiValue:(NSString*)value{
//    if (self.selectedRange.location>0) {
//        NSString* string = [self.text substringToIndex:self.selectedRange.location];
//        NSString* toString = @"";
//        NSUInteger curLocation = self.selectedRange.location;
//        if (self.selectedRange.location<self.text.length) {
//            toString = [self.text substringFromIndex:self.selectedRange.location];
//        }
//        self.text = [NSString stringWithFormat:@"%@%@%@",string,value,toString];
//        self.selectedRange =NSMakeRange(curLocation +value.length, self.selectedRange.length);
//
//    }else{
//        self.text = [NSString stringWithFormat:@"%@%@",value,self.text];
//        self.selectedRange =NSMakeRange(value.length, self.selectedRange.length);
//    }
//    
//    return;
    UIFont* defaultFont = [self.font copy];
    NSDictionary* faceDict = [FaceUtil getFaceDictionary];
    NSUInteger index = [faceDict.allValues indexOfObject:value];
    if (index != NSNotFound) {
        [self.textStorage beginEditing];

        NSString* emojiKey = [faceDict.allKeys objectAtIndex:index];
        //Create emoji attachment
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        //Set tag and image
        emojiTextAttachment.emojiTag = value;
        emojiTextAttachment.image = [UIImage imageNamed:emojiKey];
        //Insert emoji image
        [self.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                              atIndex:self.selectedRange.location];
        
        //Move selection location
        self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.selectedRange.length);
        [self resetTextStyle:defaultFont];
        [self.textStorage endEditing];
        self.font = defaultFont;
    }
}

- (void)resetTextStyle:(UIFont*)font {
    if (font) {
        //After changing text selection, should reset style.
        NSRange wholeRange = NSMakeRange(0, self.textStorage.length);
        
        [self.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
        
        [self.textStorage addAttribute:NSFontAttributeName value:font range:wholeRange];
    }
}

@end
