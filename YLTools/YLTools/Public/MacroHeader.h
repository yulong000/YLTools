//
//  MacroHeader.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

#ifdef DEBUG
#    define YLLog(...) NSLog(__VA_ARGS__)
#else
#    define YLLog(...)
#endif


#endif /* MacroHeader_h */
