use v6.d;

unit module Clipboard::macOS;

sub init-osx-pbcopy-clipboard is export {
    sub copy-osx-pbcopy($payload, :&as = {.raku}) {
        my $payload2 = &as($payload);
        $payload2 .= subst("'", '\x27'):g;
        shell "echo '$payload2' | pbcopy";
    }

    sub paste-osx-pbcopy {
        my $p = run('pbpaste', :out);
        my $stdout = $p.out.slurp(:close);
        return $stdout;
    }

    return &copy-osx-pbcopy, &paste-osx-pbcopy;
}