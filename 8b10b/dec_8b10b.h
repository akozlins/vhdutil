
/**
 * @brief 8b10b decoder state
 */
struct dec_8b10b_t {
    /// current disparity
    int disp = 0;
    /// disparity error
    int disperr = 0;
    /// decoder error
    int err = 0;
    int decode(int d10);
};

int dec_8b10b_t::decode(int d10) {
    disperr = 0;
    err = 0;

    // input 6-bit and 4-bit groups
    int g6 = d10 & 0x3F, g4 = d10 >> 6;

    int k28 = 0, kx7 = 0;
    int a7 = 0;

    // find 5-bit group encoding in G6 table
    int g5;
    for(g5 = 0; g5 < 33; g5++) {
        if(G6[g5][0] == g6) {
            // handle invalid disparity
            if(disp == 1) disperr = 1;
            break;
        }
        if(G6[g5][1] == g6) {
            if(disp == 0) disperr = 1;
            break;
        }
    }
    // K.28
    if(g5 == 32) { g5 = 28; k28 = 1; }
    if(g5 > 32) err = 1;

    // update disparity
    if(disp == 0) {
        // handle ivalid disparity
        if(popcount(g6) < 3) disperr = 1;
        else if(popcount(g6) > 3) disp = 1;
    }
    else if(disp == 1) {
        if(popcount(g6) > 3) disperr = 1;
        else if(popcount(g6) < 3) disp = 0;
    }

    // find 3-bit group in G4 table
    int g3;
    for(g3 = 0; g3 < 9; g3++) {
        if(G4[g3][0] == g4) {
            // handle ivalid disparity
            if(disp == 1) disperr = err = 1;
            break;
        }
        if(G4[g3][1] == g4) {
            if(disp == 0) disperr = err = 1;
            break;
        }
    }
    // D.x.A7
    if(g3 == 8) g3 = 7;
    if(g3 > 8) err = 1;

    // update disparity
    if(disp == 0) {
        // handle invalid disparity
        if(popcount(g4) < 2) disperr = err = 1;
        else if(popcount(g4) > 2) disp = 1;
    }
    if(disp == 1) {
        if(popcount(g4) > 2) disperr = err = 1;
        else if(popcount(g4) < 2) disp = 0;
    }

    // TODO: handle K.x.7 symbols

    if(err) return 0;

    return (g3 << 5) | g5;
}
