//
//  MenuCell.m
//  Location
//
//  Created by Nway Yu Hlaing on 23/2/16.
//
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.menuItemLabel.backgroundColor = [UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1];
    }
    else {
        self.menuItemLabel.backgroundColor = [UIColor colorWithRed:77.0/255 green:187.0/255 blue:249.0/255 alpha:1];
                
    }
}
@end
