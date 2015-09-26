#include "Dictionary.h"
#include <Windows.h>
#include <iostream>

DICTFN char GS2dict[4][16] = {
    { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R' },  //0 to 15
    { 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', '8', '9' },  //100 to 115
    { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'p', 'q', 'r' },  //200 to 215
    { 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '!', '?', '#', '&', '$', '%', '+', '=' }   //300 to 315
};

//the 2d coordinates can be obtained by /100 for row and %100 for column

//for future, optimize parser's row input
DICTFN int parser(int begin, int end, char input) {
    int rowB = begin / 100;
    int rowE = end / 100;
    for (int i = rowB; i <= rowE; i++) {
        for (int j = 0; j <= 15; j++) {
            if (input == GS2dict[i][j]) {
                return i * 100 + j;
            }
        }
    }
    return (int)input * (-1); //should never go to here if inputs are sanitized
}

DICTFN int lookup(int input) { //this was prepared according to ANSI code chart
    (char)input;  //AHK can't pass on chars for some unknown reason, or it's just me...
    if (input >= 'A' && input <= 'Z') {
        //lookup from 000 to 107
        //std::cout << "Made it to parser at least" << std::endl;  //DEBUG
        return parser(0, 107, input);
    }
    else if (input >= 'a' && input <= 'z') {
        //lookup from 200 to 207
        return parser(200, 307, input);
    }
    else if (input >= '2' && input <= '9') {
        //lookup from 108 to 115
        return parser(108, 115, input);
    }
    else { //all the random symbols
        //lookup from 308 to 315
        return parser(308, 315, input);
    }
}
