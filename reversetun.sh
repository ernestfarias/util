JPPORT=4444
ssh -f -L "$JPPORT":h1.dev.internal.com:22 devuser@jumps.h2.cloud.com  -p 2323 -N
ssh ubuntu@localhost -p "$JPPORT"
