//
//  ImageViewViewController.m
//  Imaginarium
//
//  Created by will hunting on 5/31/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@end

@implementation ImageViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollview addSubview:self.imageView];
}

#pragma mark - Properties

- (void)setScrollview:(UIScrollView *)scrollview
{
    _scrollview = scrollview;
    _scrollview.maximumZoomScale = 2.0;
    _scrollview.minimumZoomScale = 0.2;
    _scrollview.delegate = self;
    self.scrollview.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollview.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.indicatorView stopAnimating];
}

- (UIImage *)image
{
    return self.imageView.image;
}

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Set image from image's url

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    
    if (self.url) {
        [self.indicatorView startAnimating];
        NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask* task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if ([self.url isEqual:request.URL]) {
                UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }];
        [task resume];
    }
}


@end
