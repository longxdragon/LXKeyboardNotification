//
//  LXKeyboardNotification.h
//  LXKeyboardNotification
//
//  Created by gkoudai_xl on 15/10/6.
//  Copyright © 2015年 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXKeyboardNotification : NSObject

+ (instancetype)defaultNotification;

- (void)addKeyboardNotificationForSuperView:(UIView *)view
                         superViewTopMargin:(CGFloat)topMargin;

@end
