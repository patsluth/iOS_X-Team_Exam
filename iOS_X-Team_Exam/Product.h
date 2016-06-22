//
//  Product.h
//  iOS_X-Team_Exam
//
//  Created by Pat Sluth on 2016-06-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>





@interface Product : NSObject
{
}

@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSUInteger size;
@property (strong, nonatomic, readonly) NSString *price;
@property (strong, nonatomic, readonly) NSString *face;
@property (nonatomic, readonly) NSUInteger stock;
@property (strong, nonatomic, readonly) NSArray<NSString *> *tags;

+ (instancetype)productWithDictionary:(NSDictionary *)product;

@end




