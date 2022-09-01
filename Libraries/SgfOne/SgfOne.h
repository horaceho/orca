//
//  SgfOne.h
//  Orca
//
//  Created by Horace Ho on 2022/09/01.
//

#ifndef SgfOne_h
#define SgfOne_h

#include <stdbool.h>

void sgfInit(void);
void sgfFree(void);
bool sgfArgs(const char *key, const char *value);
bool sgfLoad(const char *name);
bool sgfParse(void);
void sgfDump(void);

#endif /* SgfOne_h */
