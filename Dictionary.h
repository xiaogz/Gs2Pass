#ifndef __Dictionary_H__
#define __Dictionary_H__

#define uMap std::unordered_map<char, int>
#include <Windows.h>

#define DICTFN __declspec(dllexport) 

#ifdef __cplusplus

extern "C" {
#endif

    DICTFN int lookup(int input);
    DICTFN int parser(int begin, int end, char input);

#ifdef __cplusplus
}
#endif

#endif __Dictionary_H__
