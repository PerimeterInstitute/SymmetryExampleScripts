input = $CommandLine[[5]];

n = ToExpression[input];
WriteString[$Output, "Handling a complex expression with n: ", n, "\n"];

Expand[Sum[x^i, {i, 0, n}]^n];

WriteString["Done.\n"];
