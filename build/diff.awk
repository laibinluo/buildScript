{
    if (NF == 2) {
        proj = $2;
    } else if (NF == 1) {
        ver = $1
        if (NR == FNR) {
            f1[proj] = ver;
        } else {
            f2[proj] = ver;
        }
    }
}

END {
    no_diff = 1;
    print "-------------------------------------------------"
    for (proj in f2) {
        if (!(proj in f1)) {
            no_diff = 0;
            print proj " --- [NEW]";
            print "-------------------------------------------------"
        } else if (f1[proj] != f2[proj]) {
            no_diff = 0;
            print proj " --- [MODIFY]";
            gitcmd = "git --git-dir="proj".git log --pretty=oneline " f1[proj]".."f2[proj];
            system(gitcmd);
            print "-------------------------------------------------"
        }
        delete f1[proj];
    } 
    for (proj in f1) {
        no_diff = 0;
        print proj " --- [DELETE]";
        print "-------------------------------------------------"
    }
    if (no_diff) {
        print "[NO DIFF]";
        print "-------------------------------------------------"
	exit(1);
    }
}
