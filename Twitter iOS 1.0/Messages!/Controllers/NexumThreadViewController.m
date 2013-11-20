//
//  NexumThreadViewController.m
//  Twitter iOS 1.0
//
//  Created by Cristian Castillo on 11/16/13.
//  Copyright (c) 2013 NexumDigital Inc. All rights reserved.
//

#import "NexumThreadViewController.h"

@interface NexumThreadViewController ()

@end

@implementation NexumThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.messages = [NSArray array];
    
    [self.inputBar initFrame:(UIDeviceOrientationIsPortrait(self.interfaceOrientation))];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustViewForKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *params = [NSString stringWithFormat:@"identifier=%@", self.thread[@"identifier"]];
    [NexumBackend apiRequest:@"GET" forPath:@"messages/twitter" withParams:params andBlock:^(BOOL success, NSDictionary *data) {
        if(success){
            self.messages = data[@"messages_data"];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:nil waitUntilDone:YES];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int screenWidth;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if(UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        screenWidth = screenRect.size.width;
    } else {
        screenWidth = screenRect.size.height;
    }
    
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    NSString *messageTextString = message[@"text"];
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey: NSFontAttributeName];
    CGSize viewSize = [messageTextString boundingRectWithSize:CGSizeMake((screenWidth - 110), FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:stringAttributes context:nil].size;
    return (viewSize.height +  25);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageCell";
    NexumMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    [cell reuseCell:(UIDeviceOrientationIsPortrait(self.interfaceOrientation)) withMessage:message andQueue:self.imagesQueue];
    
    return cell;
}

#pragma mark - Keyboard notifications

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.animatingRotation = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.animatingRotation = NO;
    
    [self.inputBar updateFrame:(UIDeviceOrientationIsPortrait(self.interfaceOrientation)) withOrigin:self.keyboardFrame.origin.y andAnimation:YES];
    [self.tableView updateFrame:(UIDeviceOrientationIsPortrait(self.interfaceOrientation)) withOrigin:self.keyboardFrame.origin.y andAnimation:NO];
    [self.tableView reloadData];
}

- (void)adjustViewForKeyboardNotification:(NSNotification *)notification {
    NSDictionary *notificationInfo = [notification userInfo];
    
    self.keyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self.view convertRect:self.keyboardFrame fromView:self.view.window];

    [self.inputBar updateFrame:(UIDeviceOrientationIsPortrait(self.interfaceOrientation)) withOrigin:self.keyboardFrame.origin.y andAnimation:(!self.animatingRotation)];
    [self.tableView updateFrame:(UIDeviceOrientationIsPortrait(self.interfaceOrientation)) withOrigin:self.keyboardFrame.origin.y andAnimation:(!self.animatingRotation)];
}

#pragma mark - Util

-(void) scrollToBottom {
    if(0 < [self.messages count]){
        NSIndexPath* bottomIndex = [NSIndexPath indexPathForRow:([self.messages count]-1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:bottomIndex atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView setNeedsLayout];
    }
}

@end
