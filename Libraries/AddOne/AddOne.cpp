//
//  AddOne.cpp
//  Cpp (iOS)
//
//  Created by Horace Ho on 31/8/2022.
//

#include "AddOne.hpp"

AddOne::AddOne(int _number) : number(_number + 1)
{
}

int AddOne::getAnswer()
{
    return number;
}
