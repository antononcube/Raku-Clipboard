unit module Clipboard::Linux;

sub init-xclip-clipboard is export {
    my $DEFAULT-SELECTION = 'c';
    my $PRIMARY-SELECTION = 'p';

    sub copy-xclip(Str $text is copy, Bool :$primary = False, :&as = {.raku}) {
        $text = &as($text); # Converts non-Str values to Str.
        my $selection = $DEFAULT-SELECTION;
        if $primary {
            $selection = $PRIMARY-SELECTION;
        }
        my $p = run('xclip', '-selection', $selection, :in($text.encode));
    }

    sub paste-xclip(Bool :$primary = False) {
        my $selection = $DEFAULT-SELECTION;
        if $primary {
            $selection = $PRIMARY-SELECTION;
        }
        my $p = run('xclip', '-selection', $selection, '-o', :out);
        my $stdout = $p.out.slurp;
        return $stdout.decode;
    }

    return &copy-xclip, &paste-xclip;
}


sub init-xsel-clipboard is export {
    my $DEFAULT-SELECTION = '-b';
    my $PRIMARY-SELECTION = '-p';

    sub copy-xsel($payload is copy, Bool :$primary = False, :&as = {.raku}) {
        $payload = &as($payload);
        my $selection-flag = $DEFAULT-SELECTION;
        if $primary {
            $selection-flag = $PRIMARY-SELECTION;
        }
        my $p = run('xsel', $selection-flag, '-i', :in($payload.encode));
    }

    sub paste-xsel(Bool :$primary = False) {
        my $selection-flag = $DEFAULT-SELECTION;
        if $primary {
            $selection-flag = $PRIMARY-SELECTION;
        }
        my $p = run('xsel', $selection-flag, '-o', :out);
        my $stdout = $p.out.slurp;
        return $stdout.decode;
    }

    return &copy-xsel, &paste-xsel;
}

sub init-wl-clipboard is export {
    my $PRIMARY-SELECTION = "-p";

    sub copy-wl($payload is copy, Bool :$primary = False, :&as = {.raku}) {
        $payload = &as($payload);
        my @args = <wl-copy>;
        @args.push($PRIMARY-SELECTION) if $primary;

        if !$payload {
            @args.push('--clear');
            run(|@args);
        } else {
            my $p = run(|@args, :in($payload.encode));
        }
    }

    sub paste-wl(Bool :$primary = False) {
        my @args = <wl-paste -n>;
        @args.push($PRIMARY-SELECTION) if $primary;
        my $p = run(|@args, :out);
        my $stdout = $p.out.slurp;
        return $stdout.decode;
    }

    return &copy-wl, &paste-wl;
}
