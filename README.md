iOSNetworkHandler
=================

Handler for network related retrieve behavior, such as HTTP/HTTPS

Example:

[HTTP/HTTPS webpage retrieve]

	- (void) doNetworkStuff
	{
    	HttpHeader *header = [[HttpHeader alloc] init];
    	[header setHeader:HTTP_HOST value:@"www.google.com"];
    	[header setHeader:HTTP_ACCEPT value:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"];
    	[header setHeader:HTTP_CONNECTION value:@"keep-alive"];
    	[header setHeader:HTTP_USER_AGENT value:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36"];
    
    	HttpResponse *response = [NetworkHandler get:@"https://www.google.com" withData:nil withSSL:YES header:header];
    	NSLog(@"Resposne status=%d", [response getMStatusCode]);
    	NSLog(@"Resposne body=%@", [response getMResponse]);
	}
