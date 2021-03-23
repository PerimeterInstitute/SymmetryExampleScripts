println("Using multiple processes in Julia")

println("nworkers: $(nworkers())")

@everywhere println("hostname: $(gethostname())")

println("Done.")
