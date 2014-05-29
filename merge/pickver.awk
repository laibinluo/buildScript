{
    if (NF == 2) {
        proj = $2;
    } else if (NF == 1) {
        if (NR == FNR) {
            f1[proj] = $1;
        } else {
            if (proj in f1)
                $1 = f1[proj];
        }
    }
    if (NR != FNR) {
       print $0
    }
}
