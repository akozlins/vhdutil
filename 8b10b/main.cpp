
#include <bitset>
#include <iostream>

#include <stdio.h>

int ones(int x) {
    int n = 0;
    while(x > 0) {
        if(x & 1) n++;
        x = x >> 1;
    }
    return n;
}

std::string bits(int n, int x) {
    std::string s = "";
    for(int i = 0; i < n; i++) {
        s = s + ((x & 1) ? "1" : "0");
        x = x >> 1;
    }
    return s;
}

int D6[32][2] {
    { 0b111001, 0b000110 },
    { 0b101110, 0b010001 },
    { 0b101101, 0b010010 },
    { 0b100011, 0b0 },
    { 0b101011, 0b010100 },
    { 0b100101, 0b0 },
    { 0b100110, 0b0 },
    { 0b000111, 0b111000 },
    { 0b100111, 0b011000 },
    { 0b101001, 0b0 },
    { 0b101010, 0b0 },
    { 0b001011, 0b0 },
    { 0b101100, 0b0 },
    { 0b001101, 0b0 },
    { 0b001110, 0b0 },
    { 0b111010, 0b000101 },
    { 0b110110, 0b001001 },
    { 0b110001, 0b0 },
    { 0b110010, 0b0 },
    { 0b010011, 0b0 },
    { 0b110100, 0b0 },
    { 0b010101, 0b0 },
    { 0b010110, 0b0 },
    { 0b010111, 0b101000 },
    { 0b110011, 0b001100 },
    { 0b011001, 0b0 },
    { 0b011010, 0b0 },
    { 0b011011, 0b100100 },
    { 0b011100, 0b0 },
    { 0b011101, 0b100010 },
    { 0b011110, 0b100001 },
    { 0b110101, 0b001010 },
};

int K28[2] = { 0b111100, 0b000011 };

int D4[8][2] {
    { 0b1101, 0b0010 },
    { 0b1001, 0b0 },
    { 0b1010, 0b0 },
    { 0b0011, 0b1100 },
    { 0b1011, 0b0100 },
    { 0b0101, 0b0 },
    { 0b0110, 0b0 },
    { 0b0111, 0b1000 },
};

int K4[8][2] {
    { 0b1101, 0b0010 },
    { 0b0110, 0b1001 },
    { 0b0101, 0b1010 },
    { 0b0011, 0b1100 },
    { 0b1011, 0b0100 },
    { 0b1010, 0b0101 },
    { 0b1001, 0b0110 },
    { 0b1110, 0b0001 },
};

int encode(int disp, int k, int d8) {
    int err = 0;

    int d5 = d8 & 0x1F, d3 = (d8 >> 5) & 0x7;

    int d6 = D6[d5][disp];
    if(d6 == 0) d6 = D6[d5][0];
    if(k) {
        if(d5 == 28) d6 = K28[disp];
        else if(d3 == 7 && (d5 == 23 || d5 == 27 || d5 == 29 || d5 == 30)) ;
        else { err = 1; k = 0; }
    }

    if(disp == 0 && ones(d6) > 3) disp = 1;
    else if(disp == 1 && ones(d6) < 3) disp = 0;

    int d4 = D4[d3][disp];
    if(d4 == 0) d4 = D4[d3][0];
    if(d3 == 7 && disp == 0 && (d5 == 17 || d5 == 18 || d5 == 20)) d4 = K4[d3][disp];
    if(d3 == 7 && disp == 1 && (d5 == 11 || d5 == 13 || d5 == 14)) d4 = K4[d3][disp];
    if(k) d4 = K4[d3][disp];

    if(disp == 0 && ones(d4) > 2) disp = 1;
    else if(disp == 1 && ones(d4) < 2) disp = 0;

    if(err) return 0;

    return (d4 << 6) | d6 | (disp << 16);
}

int decode(int disp, int d10) {
    return 0;
}

int main() {
    for(int k : { 0, 1 }) for(int d8 = 0; d8 < 256; d8++) for(int dispin : { 0, 1 }) {
        int d10 = encode(dispin, k, d8);
        if(d10 == 0) continue;
        int dispout = d10 >> 16;
        d10 = d10 & 0xFFFF;
        printf("%s%02d.%d ", k ? "K" : "D", d8 & 0x1F, d8 >> 5);
        std::cout << (dispin ? "+" : "-") << " " << std::bitset<8>(d8) << " => "
                  << std::bitset<10>(d10) << " " << (dispout ? "+" : "-") << std::endl;
    }

    return 0;
}
