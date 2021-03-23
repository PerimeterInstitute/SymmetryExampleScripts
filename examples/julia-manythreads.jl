println("Multiplying two large matrices...")
n = 20000

A = randn(n, n)
B = randn(n, n)

(C, t) = @timed A*B

println("Run time in seconds: $t")
ops = 2*n^3
flopRate = 40 * 32 * 2.4e9
println("Theoretical run time in seconds: $(ops / flopRate)")

println("Done.")
