//
//  AddOneWapper.cpp
//  Cpp (iOS)
//
//  Created by Horace Ho on 31/8/2022.
//

#include "AddOne.hpp"

extern "C" int addOneGetAnswer(int number)
{
    return AddOne(number).getAnswer();
}
