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
    if (debug) NSLog(@"%s", __func__);

    sgf = NULL;
    return self;
}

- (void)dealloc
{
    if (sgf) {
        FreeSGFInfo(sgf);
        sgf = NULL;
    }

    if (debug) NSLog(@"%s", __func__);
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
    const int argc = 4;
    const char *argv[argc] = {
        "-w",
        "-d17", // removed empty value
        "-d40", // property not part of FF[x]
        "-U",
    };
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
    return (cursor && cursor->parent) ? YES : NO;
}

- (BOOL)hasChild
{
    return (cursor && cursor->child) ? YES : NO;
}

- (BOOL)hasSibling
{
    return (cursor && cursor->sibling) ? YES : NO;
}

- (BOOL)isMove
{
    if (!cursor) return NO;

    return (cursor->prop->flags & TYPE_MOVE) ? YES : NO;
}

- (BOOL)isNode
{
    return (cursor != NULL) ? YES : NO;
}

- (void)gotoRoot
{
    cursor = sgf->info->root;
    if (debug) [self printBoard:cursor];
}

- (void)gotoTail
{
    struct Node* tail = NULL;
    for (struct Node *node = sgf->info->root; node; node = node->child) {
        tail = node;
    }
    cursor = tail;
    if (debug) [self printBoard:cursor];
}

- (void)gotoParent
{
    cursor = cursor->parent;
    if (debug) [self printBoard:cursor];
}

- (void)gotoChild
{
    cursor = cursor->child;
    if (debug) [self printBoard:cursor];
}

- (void)gotoSibling
{
    cursor = cursor->sibling;
    if (debug) [self printBoard:cursor];
}

- (void)exitSibling
{
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
    if (debug) [self printBoard:cursor];
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

- (NSDictionary *)props
{
    NSMutableDictionary *props = [[NSMutableDictionary alloc] init];

    if (cursor) {
        for (struct Property *property = cursor->prop; property; property = property->next) {
            NSMutableArray *values = [NSMutableArray array];
            for (struct PropValue *value = property->value; value; value = value->next) {
                char *value1 = value->value  ? value->value  : "";
                char *colon  = value->value2 ? ":" : "";
                char *value2 = value->value2 ? value->value2 : "";
                NSString *value = [NSString stringWithFormat:@"[%@%@%@]",
                                  [NSString stringWithUTF8String:value1],
                                  [NSString stringWithUTF8String:colon],
                                  [NSString stringWithUTF8String:value2]];
                [values addObject: value];
            }
            [props setObject:values forKey:[NSString stringWithUTF8String:property->idstr]];
        }
    }

    return props;
}

- (NSArray<NSNumber *> *)board
{
    NSMutableArray *board = [NSMutableArray array];
    if (cursor) {
        unsigned int area = (unsigned int)(cursor->status->bwidth * cursor->status->bheight);
        for (unsigned int index = 0; index < area; index++) {
            unsigned char color = cursor->status->board[index];
            switch(color) {
                case BLACK: [board addObject:[NSNumber numberWithInteger:1]]; break;
                case WHITE: [board addObject:[NSNumber numberWithInteger:2]]; break;
                default: [board addObject:[NSNumber numberWithInteger:0]];
            }
        }
    }
    return board;
}

- (NSArray<NSNumber *> *)marks
{
    NSMutableArray *marks = [NSMutableArray array];

    return marks;
}

- (void)printAll
{
    int moveCount = 0;
    int nodeCount = 0;
    for (struct Node* node = sgf->root; node; node = node->child) {
        nodeCount++;
        if (node->prop->flags & TYPE_MOVE) {
            moveCount++;
            printf("%03d/%03d ", moveCount, nodeCount);
        } else {
            printf("---/%03d ", nodeCount);
        }

        for (struct Property *property = node->prop; property; property = property->next) {
            printf("%s", property->idstr);
            for (struct PropValue *value = property->value; value; value = value->next) {
                char *value1 = value->value  ? value->value  : "";
                char *colon  = value->value2 ? ":" : "";
                char *value2 = value->value2 ? value->value2 : "";
                printf("[%s%s%s]", value1, colon, value2);
            }
            printf("\n");
        }

        [self printBoard:node];
        [self printMarkup:node];
    }
}

- (void)printBoard:(struct Node *)node
{
    if (node->status) {
        for (int row = 0; row < sgf->info->bheight; row++) {
            for (int col = 0; col < sgf->info->bwidth; col++) {
                size_t index = row * node->status->bwidth + col;
                unsigned char color = node->status->board[index];
                char *grid = NULL;
                switch(color)
                {
                    case EMPTY: grid = " ."; break;
                    case BLACK: grid = " B"; break;
                    case WHITE: grid = " W"; break;
                    default: grid = " .";
                }
                printf("%s", grid);
            }
            printf("\n");
        }
        printf("\n");
    }
}

- (void)printMarkup:(struct Node *)node
{
    if (node->status) {
        for (int row = 0; row < sgf->info->bheight; row++) {
            for (int col = 0; col < sgf->info->bwidth; col++) {
                size_t index = row * node->status->bwidth + col;
                unsigned short mark = node->status->markup[index];
                char buffer[16];
                if (mark != 0) {
                    sprintf(buffer, "%2d", mark);
                } else {
                    strcpy(buffer, " .");
                }
                printf("%s", buffer);
            }
            printf("\n");
        }
        printf("\n");
    }
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
