//
//  ViewTableViewCell.m
//  YLTools
//
//  Created by weiyulong on 2019/8/5.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "ViewTableViewCell.h"

@implementation ViewTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ViewTableViewCell";
    ViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[ViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
