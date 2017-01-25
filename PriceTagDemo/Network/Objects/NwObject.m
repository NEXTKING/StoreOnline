//
//  NwobjHello.m
//  MobileBanking
//
//  Created by Sergey Sasin on 15.04.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "NwObject.h"
#import "AppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>

#import "Logger.h"

@implementation NwObject
@synthesize progress = _progress;
@synthesize error    = _error;

#pragma mark * NwObject

- (id)init 
{
    self = [super init];
    if (self) 
    {
#ifdef DEBUG
        [Logger log:self method:@"init" format:@""];
#endif

        _http_method = HTTP_METHOD_GET;
        _exec_request = Nil;
        _exec_connection = Nil;
        _exec_data = [[NSMutableData alloc] initWithLength:0];
        
        _cookies = [[NSMutableDictionary alloc] initWithCapacity:1];
        _progress = [[NSProgress alloc] init];
    }
    return self;
}


- (void)dealloc
{
#ifdef DEBUG
    [Logger log:self method:@"dealloc" format:@""];
#endif
}

- (NSString*) percentEncode:(NSString*)clearValue
{
    NSString *_encodedValue = [clearValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return _encodedValue;
}

- (NSString*) percentDecode:(NSString*)percentValue
{
    NSString *_decodedValue = [percentValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return _decodedValue;
}

- (void) run: (NSString*) url
{    
    // enable network activity indicator
    if ( [[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]] )
    {
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate enableNetworkIndicator];
    }
    
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Debug" message:[NSString stringWithFormat:@"%@", [_exec_connection currentRequest]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //[alert show];
}

- (void) complete: (BOOL) isSuccessfull
{
    // disable network activity indicator
    if ( [[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]] )
    {
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate disableNetworkIndicator];
    }
}

- (void) cancel
{
    // disable network activity indicator
    if ( [[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]] )
    {
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate disableNetworkIndicator];
    }
}

#pragma mark * Core transfer code

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
#pragma unused(theConnection)
    NSHTTPURLResponse * httpResponse;
    
    [_exec_data setLength:0];
    
    assert(theConnection == _exec_connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) 
    {
        [Logger log:self method:NSStringFromSelector(_cmd) format:@"HTTP error %zd", (ssize_t) httpResponse.statusCode];
    } 
    else 
    {
        // _progress.totalUnitCount = [httpResponse expectedContentLength];
        // Check cookies
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        if (dictionary && dictionary[@"Content-Length"])
            _progress.totalUnitCount = [dictionary[@"Content-Length"] unsignedIntegerValue];
        
        if ( dictionary )
        {
#ifdef DEBUG
            NSEnumerator *enumerator = [dictionary keyEnumerator];
            id key;
            
            while ( (key = [enumerator nextObject]) )
            {
                [Logger log:self method:NSStringFromSelector(_cmd) format:@"HTTP Header Fields: %@ = %@", (NSString*)key, (NSString*)[dictionary objectForKey:key]];
            }
#endif
            
            NSArray *array = [NSHTTPCookie cookiesWithResponseHeaderFields:dictionary forURL:_exec_url];
            if ( array )
            {
#ifdef DEBUG
                [Logger log:self method:NSStringFromSelector(_cmd) format:@"HTTP Header Cookies: size = %d", [array count]];
#endif
                for ( unsigned int i=0; i<[array count]; ++i )
                {
                    NSHTTPCookie *cookie = (NSHTTPCookie *) [array objectAtIndex:i];
#ifdef DEBUG
                    [Logger log:self method:NSStringFromSelector(_cmd) format:@"HTTP Header Cookie: %@=%@\n", [cookie name], [cookie value]];
#endif
                    [_cookies setObject:cookie.value forKey:cookie.name];
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
#pragma unused(theConnection)
    assert(theConnection == _exec_connection);
    
    [_exec_data appendData:data];
    self.progress.completedUnitCount = _exec_data.length;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
#pragma unused(theConnection)
#pragma unused(error)
    assert(theConnection == _exec_connection);
    
    // Processing done with error:
    self.error = error;
    [self complete:NO];
    
    _exec_connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
#pragma unused(theConnection)
    assert(theConnection == _exec_connection);

    // Processing done successfully:
    [self complete:YES];
    
    _exec_connection = nil;
}

#pragma mark * Secure connection processing

/*
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [Logger log:self method:@"connection" format:@"willSendRequestForAuthenticationChallenge"];
    
    //[[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    //[[challenge sender] cancelAuthenticationChallenge:challenge];
}
 */

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    [Logger log:self method:NSStringFromSelector(_cmd) format:@"canAuthenticateAgainstProtectionSpace"];
    
    /* [Logger log:self method:NSStringFromSelector(_cmd) format:@"canAuthenticateAgainstProtectionSpace"];
    
    SecTrustRef trust = [protectionSpace serverTrust];
    
    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(trust, 0);
    
    NSData* ServerCertificateData = (NSData*) SecCertificateCopyData(certificate);
    
    // Check if the certificate returned from the server is identical to the saved certificate in
    // the main bundle
    BOOL areCertificatesEqual = ([ServerCertificateData
                                  isEqualToData:[MyClass getCertificate]]);
    
    [ServerCertificateData release];
    
    if (!areCertificatesEqual)
    {
        NSLog(@"Bad Certificate, canceling request");
        [connection cancel];
    }
    
    // If the certificates are not equal we should not talk to the server;
    return areCertificatesEqual; */
    
  //  return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    return YES;
}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [Logger log:self method:NSStringFromSelector(_cmd) format:@"didCancelAuthenticationChallenge"];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [Logger log:self method:NSStringFromSelector(_cmd) format:@"didReceiveAuthenticationChallenge, protocol=%@, host=%@, realm=%@", challenge.protectionSpace.protocol, challenge.protectionSpace.host, challenge.protectionSpace.realm];
    
    if ( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] )
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

@end
