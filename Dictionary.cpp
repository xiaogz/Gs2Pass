#include "Dictionary.h"
#ifdef _DEBUG
#include <Windows.h>
#endif

namespace {

const int k_row_size = 16;

char GS2dict[4][16] = {
	{ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R' },  //0 to 15
	{ 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', '8', '9' },  //100 to 115
	{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'p', 'q', 'r' },  //200 to 215
	{ 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '!', '?', '#', '&', '$', '%', '+', '=' }   //300 to 315
};

//TODO: optimize parser's row input
int parser(const int rowB, const int rowE, const char input) {
	for (int i = rowB; i <= rowE; i++) {
		for (int j = 0; j < k_row_size; j++) {
			if (input == GS2dict[i][j]) {
#ifdef _DEBUG
                char temp[40] = { 0 };
                _itoa(i * 100 + j, temp, 10);
                MessageBoxA(NULL, temp, temp, MB_OK);
#endif
				return i * 100 + j;
			}
		}
	}
	return static_cast<int>(input * (-1)); //should never go to here if inputs are sanitized
}

}; // namespace [anonymous]

// AHK script expects a retval where the first digit indicates row and the last
// 2 digits indicate column
int lookup(int input) {
    const char ch = static_cast<const char>(input);
#ifdef _DEBUG
    MessageBoxA(NULL, &ch, &ch, MB_OK);
#endif
    if (ch >= 'A' && ch <= 'Z') {
        return parser(0, 1, ch);
    }
    else if (ch >= 'a' && ch <= 'z') {
        return parser(2, 3, ch);
    }
    else if (ch >= '2' && ch <= '9') {
        return parser(1, 1, ch);
    }
    else { //all the random symbols
        return parser(3, 3, ch);
    }
}
