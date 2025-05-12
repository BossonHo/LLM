module ripple_adder (
    input  a,
    input  b,
    input  cin,
    output sum0,
    output sum1,
    output sum2,
    output sum3,
    output carry
);

section0 (a, b, cin, sum0, carry) {
    assign sum0 = a + b + cin;
    assign carry = a & b & cin;
}

section1 (sum0, sum1, carry) {
    assign sum1 = sum0 + carry;
}

section2 (sum1, sum2, carry) {
    assign sum2 = sum1 + carry;
}

section3 (sum2, sum3, carry) {
    assign sum3 = sum2 + carry;
}