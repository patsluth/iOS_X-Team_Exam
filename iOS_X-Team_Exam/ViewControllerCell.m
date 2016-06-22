//
//  ViewControllerCell.m
//  iOS_X-Team_Exam
//
//  Created by Pat Sluth on 2016-06-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "ViewControllerCell.h"





@interface ViewControllerCell()
{
}

@property (strong, nonatomic) IBOutlet UILabel *productLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UILabel *stockLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end





@implementation ViewControllerCell

#pragma mark - Init

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.product = nil;
}

#pragma mark - ViewControllerCell

- (void)setProduct:(Product *)product
{
	_product = product;
	
	if (!_product) {
		
		[self prepareForReuse];
		
	} else {
		
		self.productLabel.text = _product.face;
		self.productLabel.font = [UIFont systemFontOfSize:_product.size];
		
		self.priceLabel.text = [NSString stringWithFormat:@"$%@", _product.price];
		self.buyButton.enabled = YES;
		
		if (_product.stock <= 0) {
			self.stockLabel.text = @"Out of Stock";
		} else {
			self.stockLabel.text = [NSString stringWithFormat:@"%lu left in stock", _product.stock];
		}
		
		[self.activityIndicator stopAnimating];
		self.activityIndicator.hidden = YES;
		
	}
}

#pragma mark - UICollectionViewCell

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.productLabel.text = @"";
	self.priceLabel.text = @"";
	self.buyButton.enabled = NO;
	self.stockLabel.text = @"";
	
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
}

@end




