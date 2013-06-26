//
//  EVGroupRequestStatementCell.m
//  Evenly
//
//  Created by Joseph Hankin on 6/25/13.
//  Copyright (c) 2013 Evenly. All rights reserved.
//

#import "EVGroupRequestStatementCell.h"

@interface EVGroupRequestStatementCell ()

@property (nonatomic, strong) NSMutableArray *lines;

@end

@implementation EVGroupRequestStatementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lines = [NSMutableArray array];
    }
    return self;
}

- (void)configureForRecord:(EVGroupRequestRecord *)record {
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lines removeAllObjects];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
