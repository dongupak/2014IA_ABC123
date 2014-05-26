/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

#import "HighScoresViewController.h"
#import "HighScoresTableViewCell.h"
#import "DataManager.h"
#import "cocoslive.h"

@implementation HighScoresViewController

@synthesize table, activityIndicator, dataManager, globalScores;

- (void) dealloc
{
	[globalScores release];
	[activityIndicator release];
	[dataManager release];
	[table release];
	[super dealloc];
}

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
	if (self = [super initWithNibName:@"HighScoresViewController" bundle:nibBundleOrNil])
	{
		self.dataManager = [DataManager sharedManager];
	}
	
	return self;
}

- (void)viewDidLoad
{
	table.backgroundColor = [UIColor clearColor];
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.activityIndicator = activity;
	[activity release];
	
	[self.view addSubview:activityIndicator];
	activityIndicator.frame = CGRectMake(281.0, 12.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
	
	[activityIndicator startAnimating];
	
	ScoreServerRequest *request = [[ScoreServerRequest alloc] initWithGameName:@"ABC123" delegate:self];
	
	[request requestScores:kQueryAllTime limit:10 offset:0 flags:kQueryFlagIgnore category:@""];
	
	[request release];
}

- (IBAction) cancel
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"removeHighScores" object:@""];
}

////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Cocoslive Delegate ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

-(void) scoreRequestOk: (id) sender
{   
	NSArray *scores = [sender parseScores]; 
	NSMutableArray *mutable = [NSMutableArray arrayWithArray:scores];
	self.globalScores = mutable;
	[table reloadData];
	
	[activityIndicator stopAnimating];
}

-(void) scoreRequestFail: (id) sender
{
	[activityIndicator stopAnimating];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score Request Failed" 
													message:@"Internet connection not available, cannot view world scores" 
												   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];        
	alert.tag = 0;
	[alert show];
	[alert release];        
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// UITableViewDelegate UITableViewDataSource Methods /////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

/*
 * set the number of rows to the number of accounts
 */
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [globalScores count];
}

/*
 * Handle change notifications for observed key paths of other objects.
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
}

/*
 * This method hides the accessory view (The right facing arrow)
 */
- (UITableViewCellAccessoryType) tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{	
    return UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

/*
 * Create cell
 */
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HighScoresTableViewCell *cell = (HighScoresTableViewCell *)[self.table dequeueReusableCellWithIdentifier:@"MyIdentifier"];
	
    if (cell == nil)
	{
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HighScoresTableViewCell" owner:self options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (HighScoresTableViewCell *) currentObject;
				[cell initStyle];
				break;
			}
		}
    }
	
	NSDictionary *s = [globalScores objectAtIndex:indexPath.row];
	
	NSString *nameStr = [s objectForKey:@"cc_playername"];
	NSString *scoreStr = [@" : " stringByAppendingString:[[s objectForKey:@"cc_score"] stringValue]];
	
	cell.globalBest.text = [nameStr stringByAppendingString:scoreStr];
		
	[cell.number setImage:[UIImage imageNamed:[[NSString stringWithFormat:@"%d", indexPath.row+1] stringByAppendingString:@".png"]]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

/*
 * Pop up an alert when the user attempts to delete a row
 */
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		
    }
}

/*
 * Select click in the table
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
