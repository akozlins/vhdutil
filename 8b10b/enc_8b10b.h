
#include <string>

int popcount(int x) {
    int n = 0;
    while(x > 0) {
        if(x & 1) n++;
        x = x >> 1;
    }
    return n;
}

/**
 * @brief LUT[5-bit input][disparity input] -> 6-bit output
 *
 * - entry 32 is K28 encoding
 */
int G6[33][2] {
    { 0b111001, 0b000110 },
    { 0b101110, 0b010001 },
    { 0b101101, 0b010010 },
    { 0b100011, 0b100011 },
    { 0b101011, 0b010100 },
    { 0b100101, 0b100101 },
    { 0b100110, 0b100110 },
    { 0b000111, 0b111000 },
    { 0b100111, 0b011000 },
    { 0b101001, 0b101001 },
    { 0b101010, 0b101010 },
    { 0b001011, 0b001011 },
    { 0b101100, 0b101100 },
    { 0b001101, 0b001101 },
    { 0b001110, 0b001110 },
    { 0b111010, 0b000101 },
    { 0b110110, 0b001001 },
    { 0b110001, 0b110001 },
    { 0b110010, 0b110010 },
    { 0b010011, 0b010011 },
    { 0b110100, 0b110100 },
    { 0b010101, 0b010101 },
    { 0b010110, 0b010110 },
    { 0b010111, 0b101000 },
    { 0b110011, 0b001100 },
    { 0b011001, 0b011001 },
    { 0b011010, 0b011010 },
    { 0b011011, 0b100100 },
    { 0b011100, 0b011100 },
    { 0b011101, 0b100010 },
    { 0b011110, 0b100001 },
    { 0b110101, 0b001010 },

    { 0b111100, 0b000011 }, // K28
};

auto& K28 = G6[32];

/**
 * @brief LUT[3-bit input][disparity input] -> 4-bit output
 *
 * - entry 8 is A7 encoding
 */
int G4[9][2] {
    { 0b1101, 0b0010 },
    { 0b1001, 0b1001 },
    { 0b1010, 0b1010 },
    { 0b0011, 0b1100 },
    { 0b1011, 0b0100 },
    { 0b0101, 0b0101 },
    { 0b0110, 0b0110 },
    { 0b0111, 0b1000 },

    { 0b1110, 0b0001 }, // A7
};

/**
 * @brief K-symbol LUT[3-bit input][disparity input] -> 4-bit output
 */
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

/**
 * @brief 8b10b encoder state
 */
struct enc_8b10b_t {
    /// current disparity
    int disp = 0;
    /// encoder error
    int err = 0;
    int encode(int d8, int k = 0);
};

int enc_8b10b_t::encode(int d8, int k) {
    err = 0;

    if(d8 > 0xFF) { k = 1; d8 &= 0xFF; }

    // input 5-bit and 3-bit groups
    int g5 = d8 & 0x1F, g3 = (d8 >> 5) & 0x7;

    int k28 = 0, kx7 = 0;
    if(k) {
        // K.28
        if(g5 == 28) k28 = 1;
        // K.x.7
        if(g3 == 7 && (g5 == 23 || g5 == 27 || g5 == 29 || g5 == 30)) kx7 = 1;
        // invalid K-symbol
        if(!k28 && !kx7) { k = 0; err = 1; }
    }
    // D.x.A7
    int a7 = 0;
    if(g3 == 7 && disp == 0 && (g5 == 17 || g5 == 18 || g5 == 20)) a7 = 1;
    if(g3 == 7 && disp == 1 && (g5 == 11 || g5 == 13 || g5 == 14)) a7 = 1;

    // 6-bit group
    int g6 = G6[g5][disp];
    if(k28) g6 = K28[disp];

    // disparity after 6-bit group
    if(disp == 0 && popcount(g6) > 3) disp = 1;
    else if(disp == 1 && popcount(g6) < 3) disp = 0;

    // 4-bit group
    int g4 = G4[g3][disp];
    if(k || a7) g4 = K4[g3][disp];

    // disparity after 4-bit group
    if(disp == 0 && popcount(g4) > 2) disp = 1;
    else if(disp == 1 && popcount(g4) < 2) disp = 0;

    return (g4 << 6) | g6;
}
