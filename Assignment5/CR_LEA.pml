#define N 5    /* number of processes in the ring */
#define L 10   /* size of buffer (>= 2*N) */
byte I;        /* will be used in init for assigning ids to nodes */

mtype = {candidate, winner};              /* symb, name */
chan q[N] = [L] of {mtype, byte};   /* asynchronous channels */

proctype nnode (chan inp, out; byte mynumber) {
    bit Active = 1, know_winner = 0;
    byte nr;

    xr inp;     /* channel assertion : exclusive recv access to channel in */
    xs out;     /* channel assertion : exclusive send access to channel out */

    printf("MSC: %d\n", mynumber);
    out ! candidate(mynumber);
end:    do
    ::  inp ? candidate(nr) ->
            if 
            ::  Active ->
                    if 
                    ::  nr > mynumber -> 
                            Active = 0;
                            out ! candidate(nr);
                    ::  nr < mynumber -> skip
                    ::  else ->
                            know_winner = 1;
                            out ! winner, nr;
                    fi
            ::  else ->
                    out ! candidate(nr)
            fi 
    ::  inp ? winner, nr ->
            if 
            ::  nr != mynumber ->
                    printf("MSC: LOST\n");
            ::  else ->
                    printf("MSC: LEADER\n");
            fi;
            if 
            ::  know_winner
            ::  else -> out ! winner, nr
            fi;
            break
    od
}

init {
    byte proc;
    byte Ini[N];
    atomic {
        I = 1;
        do
        ::  I <= N ->
                if 
                ::  Ini[I-1] == 0 && N >= I -> Ini[I-1] = I
                fi;
                I++
        ::  I > N ->
                break
        od;

        /* start all nodes in the ring */
        proc = 1;
        do
        ::  proc <= N ->
                run nnode(q[proc-1], q[proc%N], Ini[proc-1]);
                proc++
        :: proc > N ->
                break
        od
    }
}