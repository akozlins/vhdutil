
#include "8b10b.h"

#include <array>
#include <bitset>
#include <iostream>

#include <stdio.h>



std::string bits(int n, int x) {
    std::string s(n, '0');
    for(int i = 0; i < n; i++) {
        if(x & 1) s[i] = '1';
        x = x >> 1;
    }
    return s;
}

void print_enc_tb() {
    enc_8b10b_t enc;
    for(int k : { 0, 1 }) for(int d8 = 0; d8 < 256; d8++) for(int dispin : { 0, 1 }) {
        enc.disp = dispin;
        int d10 = enc.encode(d8, k);
//        if(enc.err) continue;

        int dispout = enc.disp;
        std::cout << "\"" << dispin << k << std::bitset<8>(d8) << dispout << std::bitset<10>(d10) << enc.err << "\",";
    }
    std::cout << std::endl;
}

void print_enc() {
    enc_8b10b_t enc;
    for(int k : { 0, 1 }) for(int d8 = 0; d8 < 256; d8++) for(int dispin : { 0, 1 }) {
        enc.disp = dispin;
        int d10 = enc.encode(d8, k);
        if(enc.err) continue;

        int dispout = enc.disp;
        printf("%s%02d.%d", k ? "K" : "D", d8 & 0x1F, (d8 >> 5) & 0x7);
        std::cout << " ";
        std::cout << (dispin ? "+" : "-") << " " << std::bitset<8>(d8) << " => "
                  << std::bitset<10>(d10) << " " << (dispout ? "+" : "-") << std::endl;
    }
}

void print_dec() {
    std::array<int, 1024> table[2];
    table[0].fill(-1);
    table[1].fill(-1);

    enc_8b10b_t enc;
    for(int k : { 0, 1 }) for(int d8 = 0; d8 < 256; d8++) for(int dispin : { 0, 1 }) {
        enc.disp = dispin;
        int d10 = enc.encode(d8, k);
        if(enc.err) continue;

        table[dispin][d10] = (k << 8) | d8;
    }

    for(int d10 = 0; d10 < 1024; d10++) for(int dispin : { 0, 1 }) {
        int disperr = 0;
        int err = 0;

        int d8 = table[dispin][d10];
        if(d8 < 0) {
            d8 = table[1 - dispin][d10];
            if(d8 < 0) err = 1;
            else disperr = 1;
        }

        int o6 = ones(d10 & 0x3F);
        if(dispin == 0 && o6 != 3 && o6 != 4) disperr = 1;
        if(dispin == 1 && o6 != 2 && o6 != 3) disperr = 1;
        int disp64 = dispin;
        if(dispin == 0 && o6 > 3) disp64 = 1;
        if(dispin == 1 && o6 < 3) disp64 = 0;
        int o4 = ones(d10 >> 6);
        if(disp64 == 0 && o4 != 2 && o4 != 3) disperr = 1;
        if(disp64 == 1 && o4 != 1 && o4 != 2) disperr = 1;
        int dispout = disp64;
        if(disp64 == 0 && o4 > 2) dispout = 1;
        if(disp64 == 1 && o4 < 2) dispout = 0;

//        if(d8 >= 0) printf("%s%02d.%d", (d8 >> 8) ? "K" : "D", d8 & 0x1F, (d8 >> 5) & 0x7);
//        else printf("     ");
//        std::cout << " ";

        std::cout << (dispin ? "+" : "-") << " " << std::bitset<10>(d10) << " => ";
        if(d8 >= 0) std::cout << std::bitset<9>(d8);
        else std::cout << "XXXXXXXXX";
        std::cout << " " << (dispout ? "+" : "-");
        if(disperr) std::cout << " disperr";
        std::cout << std::endl;
    }
}

int main() {
    print_dec();

    return 0;
}
