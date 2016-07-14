//
//  CRAppearance.m
//  Pods
//
//  Created by Dmitry Pashinskiy on 6/9/16.
//
//

#import "CRAppearance.h"


@interface CRAppearance ()

@property (strong, nonatomic) Class mainClass;
@property (strong, nonatomic) NSMutableArray *invocations;

@end

static NSMutableDictionary *dictionaryOfClasses = nil;

@implementation CRAppearance


#pragma mark - NSObject

- (void)forwardInvocation:(NSInvocation *)anInvocation; {
    // tell the invocation to retain arguments
    [anInvocation retainArguments];
    
    // add the invocation to the array
    [self.invocations addObject:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.mainClass instanceMethodSignatureForSelector:aSelector];
}



#pragma mark - Public Methods

// this method return the same object instance for each different class
+ (id) appearanceForClass:(Class)thisClass {
    // create the dictionary if not exists
    // use a dispatch to avoid problems in case of concurrent calls
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dictionaryOfClasses) {
            dictionaryOfClasses = [[NSMutableDictionary alloc] init];
        }
    });
    
    
    
    if (![dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)]) {
        id thisAppearance = [[self alloc] initWithClass:thisClass];
        [dictionaryOfClasses setObject:thisAppearance forKey:NSStringFromClass(thisClass)];
        return thisAppearance;
        
    } else {
        return [dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)];
        
    }
}

- (void)startForwarding:(id)sender {
    for (NSInvocation *invocation in self.invocations) {
        [invocation setTarget:sender];
        [invocation invoke];
    }
}



#pragma mark - Private Methods

- (instancetype)initWithClass:(Class)thisClass {
    
    if (self = [super init]) {
        self.mainClass = thisClass;
        self.invocations = [NSMutableArray array];
    }
    return self;
}



@end