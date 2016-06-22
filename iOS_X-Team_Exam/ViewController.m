//
//  ViewController.m
//  iOS_X-Team_Exam
//
//  Created by Pat Sluth on 2016-06-21.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "ViewController.h"

#import "ViewControllerCell.h"





@interface ViewController ()
{
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISwitch *onlyInStockSwitch;

@property (strong, nonatomic) NSMutableArray<Product *> *allProducts;
@property (strong, nonatomic) NSMutableArray<Product *> *inStockProducts;
@property (weak, nonatomic) NSMutableArray<Product *> *productDataSource;

@end





@implementation ViewController

#pragma mark - Init

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.onlyInStockSwitch addTarget:self action:@selector(onlyInStockSwitchToggled:)
					 forControlEvents:UIControlEventValueChanged];
	
	self.allProducts = [NSMutableArray new];
	self.inStockProducts = [NSMutableArray new];
	self.productDataSource = self.inStockProducts;
	
	[self loadMoreProducts:10];
}

#pragma mark - ViewController

- (void)loadMoreProducts:(NSUInteger)count
{
	NSMutableString *urlString = [NSMutableString stringWithString:@"http://74.50.59.155:5000/api/search?"];
	[urlString appendString:[NSString stringWithFormat:@"skip=%lu", self.allProducts.count]];
	[urlString appendString:[NSString stringWithFormat:@"&limit=%lu", count]];
	// Save the products in two separate arrays to handle in stock items instead of
	// separate API requests
//	[urlString appendString:[NSString stringWithFormat:@"&onlyInStock=%@", @(self.onlyInStockSwitch.on)]];
	if (self.searchBar.text) {
		[urlString appendString:[NSString stringWithFormat:@"&q=%@", self.searchBar.text.lowercaseString]];
	}
	
	
	// Get the date (to the hour) so API requests are cached for an hour
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:[NSDate date]];
	NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
	NSString *dateString = [NSString stringWithFormat:@"%@", date];
	dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
	[urlString appendString:[NSString stringWithFormat:@"&date=%@", dateString]];
	
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
	
	NSURLSessionDataTask *urlTask;
	
	urlTask = [[NSURLSession sessionWithConfiguration:config]
			   dataTaskWithURL:url
			   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
				   
				   if (!data || data.length <= 0 || error) {
					   
				   } else {
					   
					   [[NSOperationQueue mainQueue] addOperationWithBlock:^{
						   
						   NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
						   NSArray<NSString *> *jsonParts = [jsonString componentsSeparatedByString:@"\n"];
						   
						   for (NSString *json in jsonParts) {
							   
							   NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
							   NSError *error;
							   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
							   
							   if (jsonDict && !error) {
								   
								   Product *product = [Product productWithDictionary:jsonDict];
								   [self.allProducts addObject:product];
								   
								   if (product.stock > 0) {
									   [self.inStockProducts addObject:product];
								   }
								   
							   }
							   
						   }
						   
						   [self.collectionView reloadData];
						   
					   }];
					   
				   }
				   
			   }];
	
	[urlTask resume];
}

#pragma mark - ViewController

- (void)onlyInStockSwitchToggled:(UISwitch *)sender
{
	self.productDataSource = (sender.on) ? self.inStockProducts : self.allProducts;
	
	[self.collectionView reloadData];
}

#pragma mark - ViewController UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.allProducts removeAllObjects];
	[self.inStockProducts removeAllObjects];
	
	[self.collectionView reloadData];
	
	[self loadMoreProducts:10];
	
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	self.searchBar.text = @"";
	[searchBar resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.productDataSource.count;
}

- (ViewControllerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ViewControllerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ViewControllerCell" forIndexPath:indexPath];
	
	if (cell) {
		
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
	   willDisplayCell:(ViewControllerCell *)cell
	forItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row + 1 >= self.productDataSource.count) {
		
		[self loadMoreProducts:10];
		
	} else {
		
		Product *product = [self.productDataSource objectAtIndex:indexPath.row];
		cell.product = product;
		
	}
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
	forItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end




