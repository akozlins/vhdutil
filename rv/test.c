
int collatz(unsigned k);

int main() {
    collatz(3);

    while(1);

    return 0;
}

/**
 * Collatz sequence:
 * if the number is even - divide it by 2
 * if odd - multiply by 3 and add 1
 * repeat until number becomes 1
 */
int collatz(unsigned k) {
    int n = 0; // number of steps

    while(k != 1) {
        n++;
        if(k % 2 == 0) {
            k = k / 2;
        }
        else {
            if(k >= 0xFFFFFFFF / 3) return -1;
            k = 3 * k + 1;
        }
    }

    return n;
}
