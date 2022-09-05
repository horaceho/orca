//
//  GoSGF.h
//
//  Objective-C wrapper of sgfc
//
//  Created by horace on 2022/09/02
//  Copyright (c) 2022 Horace Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TokenNONE = -1,
    TokenUNKNOWN,
    TokenB,  TokenW,  TokenAB, TokenAW, TokenAE, TokenN,  TokenC,
    TokenBL, TokenWL, TokenOB, TokenOW,
    TokenFF, TokenGM, TokenSZ, TokenST, TokenCA, TokenAP,
    TokenGN, TokenGC, TokenPB, TokenPW, TokenBR, TokenWR,
    TokenPC, TokenDT, TokenRE,	TokenKM, TokenKI, TokenHA, TokenTM, TokenEV,
    TokenRO, TokenSO, TokenUS, TokenBT, TokenWT, TokenRU, TokenAN, TokenOT,
    TokenON, TokenCP,
    TokenL,	TokenLB, TokenAR, TokenLN, TokenM,  TokenMA, TokenTR, TokenCR,
    TokenTB, TokenTW, TokenSQ,	TokenSL, TokenDD,
    TokenPL, TokenV,  TokenGB, TokenGW, TokenUC, TokenDM, TokenTE,
    TokenBM, TokenDO, TokenIT, TokenHO,
    TokenKO, TokenFG, TokenMN, TokenVW, TokenPM,
    /* properties not part of FF4 */
    TokenCH, TokenSI, TokenBS, TokenWS, TokenID, TokenTC, TokenOM, TokenOP,
    TokenOV, TokenLT, TokenRG, TokenSC, TokenSE, TokenEL, TokenEX
} GoToken;

@interface GoSGF : NSObject
{
}

+ (GoSGF *)one;

- (void)setupInfo;
- (void)parseArgs;
- (void)encoding:(NSString *)encoding;
- (void)openFile:(NSString *)filename;
- (void)parseSgf;

- (BOOL)isReady;

- (BOOL)hasParent;
- (BOOL)hasChild;
- (BOOL)hasSibling;
- (BOOL)isMove;
- (BOOL)isNode;

- (void)gotoRoot;
- (void)gotoTail;
- (void)gotoParent;
- (void)gotoChild;
- (void)gotoSibling;
- (void)exitSibling;

- (NSString *)info;
- (NSDictionary<NSString *, NSArray<NSString *> *> *)props;
- (NSArray<NSNumber *> *)board;
- (NSArray<NSNumber *> *)marks;

- (void)printAll;

- (NSInteger)gameCount;

- (NSInteger)boardWidth;
- (NSInteger)boardHeight;

@end
