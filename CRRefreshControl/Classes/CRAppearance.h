//
//  CRAppearance.h
//  Pods
//
//  Created by Dmitry Pashinskiy on 6/9/16.
//
//

#import <Foundation/Foundation.h>

@interface CRAppearance : NSObject

+ (instancetype) appearanceForClass:(Class)thisClass;

- (void)startForwarding:(id)sender;

- (instancetype)init __attribute((unavailable("Use appearanceForClass: method")));
+ (instancetype)new __attribute((unavailable("Use appearanceForClass: method")));
                                   
                                   

@end
