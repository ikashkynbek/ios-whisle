//
//  wrapper.cpp
//  ios-whisle
//
//  Created by ik on 06/01/2017.
//  Copyright © 2017 ik. All rights reserved.
//

#include <iostream>
#include <cstring>
#include "Synthesizer.h"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).

extern "C" uint32_t generate(int8_t *samples, uint32_t sampleRate, uint32_t size, const char *mes)
{
    
    Synthesizer synth(sampleRate);
    return synth.generate(samples, size, mes);
}
