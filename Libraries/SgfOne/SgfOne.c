//
//  SgfOne.c
//  Orca
//
//  Created by Horace Ho on 2022/09/01.
//

#include "SgfOne.h"
#include <string.h>

#include "../sgfc/src/all.h"
#include "../sgfc/src/protos.h"

struct SGFInfo *sgf = NULL;

void sgfInit(void)
{
    if (sgf) {
        sgfFree();
    }

    sgf = SetupSGFInfo(NULL);
}

void sgfFree(void)
{
    FreeSGFInfo(sgf);
    sgf = NULL;
}

bool sgfArgs(const char *key, const char *value)
{
    if (strcmp(key, "encoding") == 0) {
        sgf->options->default_encoding = value;
    }
    return true;
}

bool sgfLoad(const char *name)
{
    return LoadSGF(sgf, name);
}

bool sgfParse(void)
{
    return ParseSGF(sgf);
}

int dumpPropValue(char *v, int second, U_SHORT flags, FILE *sfile)
{
    if (!v) return true;

    if (second) putchar(':');

    int length = 0;
//  char *str = v;
    while (*v) {
        putchar(*v);
        v++;
        length++;
    }
/*
    NSString *strUTF = [[NSString alloc] initWithBytes:str length:length encoding:NSUTF8StringEncoding];
    NSString *strCN = [[NSString alloc] initWithBytes:str length:length encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN)];
    NSString *strTW = [[NSString alloc] initWithBytes:str length:length encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_TW)];
    NSString *strJP = [[NSString alloc] initWithBytes:str length:length encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_JP)];
    NSString *strKR = [[NSString alloc] initWithBytes:str length:length encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR)];

    NSLog(@"");
    NSLog(@"%d %s UTF8: %@ CN: %@ TW: %@ JP: %@ KR: %@", length, str, strUTF, strCN, strTW, strJP, strKR);
*/
    return true;
}

int dumpProperty(struct TreeInfo *info, struct Property *prop, FILE *sfile)
{
    static int gi_written = false;

    struct PropValue *v;
    char *p;
    int do_tt;
    bool option_pass_tt = false;

    if (prop->flags & TYPE_GINFO)
    {
        if (!gi_written)
        {
            putchar('\n');
            putchar('\n');
        }
        gi_written = true;
    } else {
        gi_written = false;
    }

    p = prop->idstr; // write property ID
    while (*p) {
        putchar(*p);
        p++;
    }

    do_tt = (info->GM == 1 && option_pass_tt &&
             (info->bwidth <= 19) && (info->bheight <= 19) &&
             (prop->id == TKN_B || prop->id == TKN_W));

    v = prop->value; // write property value(s)

    while (v) {
        putchar('[');

        if (do_tt && !strlen(v->value)) {
            dumpPropValue("tt", false, prop->flags, sfile);
        } else {
            dumpPropValue(v->value, false, prop->flags, sfile);
            dumpPropValue(v->value2, true, prop->flags, sfile);
        }
        putchar(']');

     // CheckLineLen(sfile);
        v = v->next;
    }

    if (prop->flags & TYPE_GINFO) {
        putchar('\n');
        if (prop->next) {
            if (!(prop->next->flags & TYPE_GINFO))
                putchar('\n');
        } else {
            putchar('\n');
        }
    }

    return true;
}

int dumpNode(struct TreeInfo *info, struct Node *n, FILE *sfile)
{
    struct Property *p;
    putchar(';');

    p = n->prop;
    while (p) {
        if (!dumpProperty(info, p, sfile)) return false;
        p = p->next;
    }

    return true;
}

int dumpTree(struct TreeInfo *info, struct Node *n, FILE *sfile, int newlines)
{
    if (newlines) putchar('\n');

    putchar('(');
    if (!dumpNode(info, n, sfile)) return false;

    n = n->child;

    while (n) {
        if (n->sibling) {
            while(n) { // write child + variations
                if (!dumpTree(info, n, sfile, 1)) return false;
                n = n->sibling;
            }
        } else {
            if (!dumpNode(info, n, sfile)) return false;
            n = n->child;
        }
    }

    putchar(')');

    if (newlines != 1) putchar('\n');

    return true;
}

void sgfDump(void)
{
    struct Node *node;
    struct TreeInfo *info;

    node = sgf->root;
    info = sgf->tree;
    int newline = 0;

    while (node) {
        if (!dumpTree(info, node, NULL, newline)) {
            ;
        }
        newline = 2;
        node = node->sibling;
        info = info->next;
    }
}

void sgfVersion(void)
{
}
