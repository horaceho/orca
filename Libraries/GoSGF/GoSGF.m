//
//  GoSGF.m
//  GoFriends
//
//  Created by horace on 2022/09/02
//  Copyright (c) 2022 Horace Ho. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "GoSGF.h"
#import <stdio.h>
#import "all.h"
#import "protos.h"

const int UNI_SQ = 0x25A1;
const int UNI_TR = 0x25B2;

@interface GoSGF()
{
    BOOL debug;
    struct SGFInfo *sgf;
    struct Node *cursor;
    int moveMap[52*52];
    int markMap[52*52];
}

@property (nonatomic, retain) NSString *pathname;

@end

@implementation GoSGF

+ (GoSGF *)one
{
    static GoSGF *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GoSGF alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    NSLog(@"%s", __func__);
    sgf = NULL;
    return self;
}

- (void)dealloc
{
    if (sgf) {
        FreeSGFInfo(sgf);
        sgf = NULL;
    }

    NSLog(@"%s", __func__);
}

- (void)setupInfo
{
    if (sgf) {
        FreeSGFInfo(sgf);
    }

    sgf = SetupSGFInfo(NULL);
}

- (void)parseArgs
{
    int argc = 2;
    const char *argv[] = {"-w", "-U"};
    ParseArgs(sgf, argc, argv);
}

- (void)encoding:(NSString *)encoding
{
    sgf->options->default_encoding = [encoding UTF8String];
}

- (void)openFile:(NSString *)filename
{
    LoadSGF(sgf, [filename UTF8String]);
}

- (void)parseSgf
{
    ParseSGF(sgf);
}

- (BOOL)isReady
{
    BOOL isReady = NO;
    if (sgf->info && sgf->info->bwidth > 0 && sgf->info->bheight > 0) {
        isReady = YES;
    }
    return isReady;
}

- (BOOL)hasParent
{
    if (!self.isReady) return NO;
    return cursor->parent ? YES : NO;
}

- (BOOL)hasChild
{
    if (!self.isReady) return NO;
    return cursor->child ? YES : NO;
}

- (BOOL)hasSibling
{
    if (!self.isReady) return NO;
    return cursor->sibling ? YES : NO;
}

- (BOOL)inVariation
{
    if (!self.isReady) return NO;

    BOOL inVariation = NO;
    for (struct Node *node = cursor; node && !inVariation; node = node->parent) {
        if (node->parent && node->parent->child) {
            for (struct Node *sibling = node->parent->child->sibling; sibling && !inVariation; sibling = sibling->sibling) {
                if (sibling == node) {
                    inVariation = YES;
                }
            }
        }
    }
    return inVariation;
}

- (void)gotoRoot
{
    if (!self.isReady) return;

    cursor = sgf->info->root;
    if (debug) [self printNode:cursor];
}

- (void)gotoTail
{
    if (!self.isReady) return;

    struct Node* tail = NULL;
    for (struct Node *node = sgf->info->root; node; node = node->child) {
        tail = node;
    }
    if (tail) cursor = tail;
    if (debug) [self printNode:cursor];
}

- (void)gotoParent
{
    if (!self.isReady) return;

    if (cursor == sgf->info->root) return;

    cursor = cursor->parent;
    if (debug) [self printNode:cursor];
}

- (void)gotoChild
{
    if (!self.isReady) return;

    if (cursor->child == NULL) return;

    cursor = cursor->child;
    if (debug) [self printNode:cursor];
}

- (void)gotoSibling
{
    if (!self.isReady) return;

    if (cursor->sibling == NULL) return;

    cursor = cursor->sibling;
    if (debug) [self printNode:cursor];
}

- (void)exitSibling
{
    if (!self.isReady) return;

    struct Node* upper = NULL;
    for (struct Node *node = cursor; node && !upper; node = node->parent) {
        if (node->parent && node->parent->child) {
            for (struct Node *sibling = node->parent->child->sibling; sibling && !upper; sibling = sibling->sibling) {
                if (sibling == node) {
                    upper = node->parent->child;
                }
            }
        }
    }
    if (upper) cursor = upper;
    if (debug) [self printNode:cursor];
}

- (NSString *)info
{
    if (!self.isReady) return @"";

    NSString *info = @"";
 /*
    NSString *gn  = [self property:sgf->info->root token:TokenGN];
    NSString *gc  = [self property:sgf->info->root token:TokenGC];
    NSString *ev  = [self property:sgf->info->root token:TokenEV];
    NSString *ro  = [self property:sgf->info->root token:TokenRO];
    NSString *dt  = [self property:sgf->info->root token:TokenDT];
    NSString *pc  = [self property:sgf->info->root token:TokenPC];
    NSString *pw  = [self property:sgf->info->root token:TokenPW];
    NSString *wr  = [self property:sgf->info->root token:TokenWR];
    NSString *pb  = [self property:sgf->info->root token:TokenPB];
    NSString *br  = [self property:sgf->info->root token:TokenBR];
    NSString *ha  = [self property:sgf->info->root token:TokenHA];
    NSString *km  = [self property:sgf->info->root token:TokenKM];
    NSString *tm  = [self property:sgf->info->root token:TokenTM];
    NSString *re  = [self property:sgf->info->root token:TokenRE];
    NSString *on  = [self property:sgf->info->root token:TokenON];
    NSString *cp  = [self property:sgf->info->root token:TokenCP];
    NSString *so  = [self property:sgf->info->root token:TokenSO];
    NSString *an  = [self property:sgf->info->root token:TokenAN];
    NSString *ap  = [self property:sgf->info->root token:TokenAP];
    NSString *us  = [self property:sgf->info->root token:TokenUS];

    if (gn) info = [info stringByAppendingFormat:@"%@\n", gn];
    if (ev) info = [info stringByAppendingFormat:@"%@\n", ev];
    if (ro) info = [info stringByAppendingFormat:@"%@\n", ro];
    if (dt) info = [info stringByAppendingFormat:@"%@\n", dt];
    if (pc) info = [info stringByAppendingFormat:@"%@\n", pc];

    info = [info stringByAppendingFormat:@"\n"];

    if (pw && pb) {
        // white player
        info = [info stringByAppendingFormat:@"\u26AA %@", pw];
        if (wr) {
            info = [info stringByAppendingFormat:@" %@", wr];
        }
     // info = [info stringByAppendingFormat:@"%@\n", NSLocalizedString(@"WHITE_PLAYER", nil)];
        info = [info stringByAppendingString:@"\n"];

        // black player
        info = [info stringByAppendingFormat:@"\u26AB %@", pb]; //
        if (br) {
            info = [info stringByAppendingFormat:@" %@", br];
        }
     // info = [info stringByAppendingFormat:@"%@\n", NSLocalizedString(@"BLACK_PLAYER", nil)];
        info = [info stringByAppendingString:@"\n"];
    }
    if (ha) {
        NSInteger n = [ha integerValue];
        if (n > 0) {
            NSString *format;
            if (n > 1) {
                format = NSLocalizedString(@"HANDICAP_UNITS", nil);
            } else {
                format = NSLocalizedString(@"HANDICAP_UNIT", nil);
            }
            info = [info stringByAppendingFormat:format, n];
            info = [info stringByAppendingString:@"\n"];
        }
    }
    if (km && km.floatValue > 0.0) {
        NSString *komi = NSLocalizedString(@"KOMI", nil);
        info = [info stringByAppendingFormat:komi, km.floatValue];
        info = [info stringByAppendingString:@"\n"];
    }
    if (tm && tm.floatValue > 0.0) {
        NSString *time = NSLocalizedString(@"TIME", nil);
        info = [info stringByAppendingFormat:time, tm.floatValue];
        info = [info stringByAppendingString:@"\n"];
    }
    if (re) {
        info = [info stringByAppendingFormat:@"%@\n", re];
    }

    info = [info stringByAppendingString:@"\n"];

    if (gc) info = [info stringByAppendingFormat:@"%@\n", gc];
    if (on) info = [info stringByAppendingFormat:@"%@\n", on];
    if (cp) info = [info stringByAppendingFormat:@"%@\n", cp];
    if (so) info = [info stringByAppendingFormat:@"%@\n", so];
    if (an) info = [info stringByAppendingFormat:@"%@\n", an];
    if (ap) info = [info stringByAppendingFormat:@"%@\n", ap];
    if (us) info = [info stringByAppendingFormat:@"%@\n", us];
 */
    return info;
}

- (struct Property *)findProperty:(struct Node *)node token:(GoToken)token
{
    struct Property *p = NULL;
    for (struct Property *property = node->prop; property; property = property->next) {
        if (token == (GoToken) property->ident) {
            p = property;
        }
    }
    return p;
}

- (NSString *)property:(struct Node *)node token:(GoToken)token
{
    char asciiValue[1024*16];
    int valueLength = 0;
    struct Property *property = [self findProperty:node token:token];
    if (property) {
        char *value1 = property->value->value  ? property->value->value  : "";
        char *colon  = property->value->value2 ? ":" : "";
        char *value2 = property->value->value2 ? property->value->value2 : "";
        valueLength = snprintf(asciiValue, sizeof(asciiValue), "%s%s%s", value1, colon, value2);
        asciiValue[sizeof(asciiValue)-1] = '\0';
    }
    NSString *keyString = nil;
    if (valueLength > 0) {
        keyString = [[NSString alloc] initWithBytes:asciiValue length:valueLength encoding:NSUTF8StringEncoding];
    }
    return keyString;
}

- (NSString *)property:(GoToken)token
{
    NSString *property = @"";
    if ([self isReady]) {
        property = [self property:cursor token:token];
    }
    return property;
}

- (NSString *)siblingName
{
    if (!self.isReady) return @"";

    NSString *siblingName = nil;
    if (cursor->sibling) {
        siblingName = [self property:cursor->sibling token:TokenN]; // node name
        siblingName = [siblingName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (siblingName.length == 0) {
         /*
            siblingName = [self property:cursor->sibling token:TokenC]; // comment
            if (siblingName.length == 0) {
                siblingName = @"...";
            } else if (siblingName.length > 8) {
                siblingName = [NSString stringWithFormat:@"%@...", [siblingName substringToIndex:8]];
            }
         */
            siblingName = NSLocalizedString(@"Variation", nil);
        }
    }
    return siblingName;
}

- (void)printAll
{
    int moveCount = 0;
    int nodecount = 0;
    for (struct Node* node = sgf->root; node; node = node->child) {
        if (node->prop->flags & TYPE_MOVE) {
            moveCount++;
        }
        printf("%03d/%03d ", moveCount, nodecount);

        for (struct Property *property = node->prop; property; property = property->next) {
            char *value1 = property->value->value  ? property->value->value  : "";
            char *colon  = property->value->value2 ? ":" : "";
            char *value2 = property->value->value2 ? property->value->value2 : "";
            printf("%s[%s%s%s] ", property->idstr, value1, colon, value2);
        }
        printf("\n");
        nodecount++;
    }

    NSLog(@"Trees: %d FF: %d GM: %d %d x %d Moves: %d",
          sgf->info->num, sgf->info->FF, sgf->info->GM, sgf->info->bwidth, sgf->info->bheight, moveCount);
}

- (void)printProperty:(struct Property *)property
{
    printf("%s: ", property->idstr);
    for (struct PropValue *value = property->value; value; value = value->next) {
        if (value->value) printf("%s", value->value);
        if (value->value2) printf(":%s", value->value2);
        printf(" ");
    }
}

- (void)printNode:(struct Node *)node
{
#undef PRINT_BOARD
#ifdef PRINT_BOARD
    if (node->status) {
        for (int row = 0; row < sgf->info->bheight; row++) {
            for (int col = 0; col < sgf->info->bwidth; col++) {
                size_t index = row * node->status->bwidth + col;
                unsigned char color = node->status->board[index];
                char *grid = ". ";
                switch(color)
                {
                    case EMPTY: break;
                    case BLACK: grid = "B "; break;
                    case WHITE: grid = "W "; break;
                }
                printf("%s", grid);
            }
            printf("\n");
        }
        printf("\n");
    }
#endif
    printf("printNode: Col: %ld Row: %ld Properties: ", node->col, node->row);
    for (struct Property *property = node->prop; property; property = property->next) {
        [self printProperty:property];
    }
    printf("\n");
}

- (void)printNode
{
    if (cursor == NULL) {
        cursor = sgf->info->root;
    }
    [self printNode:cursor];
}

- (NSInteger)gameCount
{
    return sgf->info->num;
}

- (NSInteger)boardWidth
{
    return sgf->info->bwidth;
}

- (NSInteger)boardHeight
{
    return sgf->info->bheight;
}

@end
