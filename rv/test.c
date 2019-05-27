
int test();

int main() {
    return test();
}

int add(int a, int b) {
    return a + b;
}

int sub(int a, int b) {
    return a - b;
}

int test() {
    int s = 0;
    for(int i = 0; i < 16; i++) {
        s = add(s, 42);
        s = sub(s, 1);
    }
    return s;
}
