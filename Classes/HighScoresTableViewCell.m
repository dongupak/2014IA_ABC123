/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "HighScoresTableViewCell.h"

@implementation HighScoresTableViewCell

@synthesize number, globalBest;

- (void)dealloc
{
	[globalBest release];
	[number release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		// Initialization code
	}
	
	return self;
}

- (void) initStyle
{
	//levelIndicator.font = [UIFont fontWithName:@"Marker Felt" size:20.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

@end
