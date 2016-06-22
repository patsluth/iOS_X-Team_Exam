//
//  Product.m
//  iOS_X-Team_Exam
//
//  Created by Pat Sluth on 2016-06-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "Product.h"

static const NSString *ProductKey_Face = @"face";
static const NSString *ProductKey_ID = @"id";
static const NSString *ProductKey_Price = @"price";
static const NSString *ProductKey_Size = @"size";
static const NSString *ProductKey_Stock = @"stock";
static const NSString *ProductKey_Tags = @"tags";
static const NSString *ProductKey_Type = @"type";





@interface Product()
{
}

@property (strong, nonatomic, readwrite) NSString *type;
@property (strong, nonatomic, readwrite) NSString *identifier;
@property (nonatomic, readwrite) NSUInteger size;
@property (strong, nonatomic, readwrite) NSString *price;
@property (strong, nonatomic, readwrite) NSString *face;
@property (nonatomic, readwrite) NSUInteger stock;
@property (strong, nonatomic, readwrite) NSArray<NSString *> *tags;

@end





@implementation Product

#pragma mark - Init

+ (instancetype)productWithDictionary:(NSDictionary *)product
{
	Product *p = [Product new];
	
	p.type = product[ProductKey_Type];
	p.identifier = product[ProductKey_ID];
	p.size = [product[ProductKey_Size] unsignedIntegerValue];
	
	NSMutableString *_price = [NSMutableString stringWithFormat:@"%@", product[ProductKey_Price]];
	[_price insertString:@"." atIndex:_price.length - 2];
	p.price = [_price copy];
	
	p.face = product[ProductKey_Face];
	p.stock = [product[ProductKey_Stock] unsignedIntegerValue];
	p.tags = product[ProductKey_Tags];
	
	return p;
}

#pragma mark - Product

@end




