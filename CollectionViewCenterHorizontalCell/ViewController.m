//
//  ViewController.m
//  CollectionViewCenterHorizontalCell
//
//  Created by mtaxi on 2019/7/26.
//  Copyright © 2019 leo. All rights reserved.
//

#import "ViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kItemWidth (kScreenWidth / 375)*135;
#define kSectionPadding (kScreenWidth / 375)*120;
#define kItemPadding (kScreenWidth / 375)*70;
#define kArrayCount 10;
#define kcellIdentifier @"cell"
@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout

>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic, assign) CGFloat currentPage;
@property(nonatomic, strong)UICollectionViewCell *cell;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.mainCollectionView.delegate = self;
	self.mainCollectionView.dataSource = self;
	self.mainCollectionView.backgroundColor = [UIColor greenColor];
	self.currentPage = 0;
	
	self.cell = [UICollectionViewCell new];
	
	[self.mainCollectionView registerClass:[self.cell class] forCellWithReuseIdentifier:kcellIdentifier];
	
	//添加拖移手勢
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
	[self.mainCollectionView addGestureRecognizer:panGesture];
	
	//	//添加左滑手勢
	//	UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
	//	[recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	//	recognizerLeft.delegate = self;
	//	[self.mainCollectionView addGestureRecognizer:recognizerLeft];
	//
	//	//添加右滑手勢
	//	UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
	//	[recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
	//	recognizerRight.delegate = self;
	//	[self.mainCollectionView addGestureRecognizer:recognizerRight];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	//collectionCell 點選時置中
	[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	
	self.currentPage = indexPath.item;
	
	NSLog(@"點到第%d頁了",(int)self.currentPage);
	
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return kArrayCount;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	self.cell = [_mainCollectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
	CGFloat red = 255.0/indexPath.item;
	self.cell.backgroundColor = [UIColor colorWithRed:red/255.0 green:43/255.0 blue:48/255.0 alpha:1.0];
	
	return self.cell;
	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat w = kItemWidth;
	CGSize size = CGSizeMake(w, CGRectGetHeight(collectionView.frame));
	
	return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	//item橫項間距
	return kItemPadding;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	//Section上左下右間距
	float leftPadding = kSectionPadding;
	float rightPadding = kSectionPadding;
	return UIEdgeInsetsMake(0, leftPadding, 0, rightPadding);
}

#pragma mark UISwipeGestureRecognizer
- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
	CGPoint point = [gesture translationInView:self.mainCollectionView];

	if (gesture.state == UIGestureRecognizerStateEnded) {
		if(point.x < 0) {
			//向左滑＋＋
			int offsetX = -(int)point.x;
			int arrayCount = kArrayCount;
			int maxPage = arrayCount - 1;
			if (self.currentPage < maxPage) {
				if (offsetX > 50) {
					int offsetPage = offsetX/50;
					self.currentPage = self.currentPage + offsetPage;
					if (self.currentPage > maxPage) {
						self.currentPage = maxPage;
					}
				}else{
					self.currentPage = self.currentPage + 1;
				}
			}

			NSLog(@"swipe left");

		}
		if(point.x > 0) {
			//向右滑－－
			int offsetX = (int)point.x;
			int minPage = 0;
			if (self.currentPage > minPage) {
				if (offsetX > 50) {
					int offsetPage = offsetX/50;
					self.currentPage = self.currentPage - offsetPage;
					if (self.currentPage < minPage) {
						self.currentPage = minPage;
					}
				}else{
					self.currentPage = self.currentPage - 1;
				}
			}
			NSLog(@"swipe right");

		}

		NSLog(@"滑到第%d頁了",(int)self.currentPage);

		[self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
	}

}


//-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
//	if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//		//向左滑＋＋
//		int arrayCount = kArrayCount;
//		if (self.currentPage < arrayCount - 1) {
//		self.currentPage = self.currentPage + 1;
//		}
//		NSLog(@"swipe left");
//
//	}
//	if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//		//向右滑－－
//		self.currentPage = self.currentPage - 1;
//		if (self.currentPage < 0) {
//			self.currentPage = 0;
//		}
//		NSLog(@"swipe right");
//
//	}
//
//	NSLog(@"滑到第%d頁了",(int)self.currentPage);
//
//	[self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//	//使用UISwipeGestureRecognizer設為true
//	return true;
//}

@end
