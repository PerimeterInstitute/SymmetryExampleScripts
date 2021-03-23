WriteString[$Output, "Multiplying two large matrices...\n"];
n = 20000;

A = RandomReal[{0, 1}, {n, n}];
B = RandomReal[{0, 1}, {n, n}];

{time, AB} = AbsoluteTiming[A.B];

WriteString[$Output, "Run time in seconds: ", time, "\n"];
ops = 2*n^3;
flopRate = 40 * 32 * 2.4*^9;
WriteString[$Output, "Theoretical run time in seconds: ", ops / flopRate, "\n"];

WriteString[$Output, "Done.\n"];
