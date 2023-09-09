use v6.d;

unit module Clipboard;

#===========================================================
# Copy
#===========================================================

#| Replaces the contents of the clipboard with the first argument
#| If the first argument is not a string then it is converted to one with .raku.
#| If $clipboard-command is the empty string then no copying to the clipboard is done.
#| If $clipboard-command is Whatever or 'Whatever' then:
#| 1. It is attempted to use the environment variable CLIPBOARD_COPY_COMMAND.
#|   If CLIPBOARD_COPY_COMMAND is defined and it is the empty string then no copying to the clipboard is done.
#| 2. If the variable CLIPBOARD_COPY_COMMAND is not defined then:
#|   - 'pbcopy' is used on macOS
#|   - 'clip.exe' on Windows
#|   - 'xclip -selection clipboard' on Linux.
proto copy-to-clipboard(|) is export(:DEFAULT, :ALL, :long-names) {*}

do given $*DISTRO {
    when $_.is-win { 
    require Clipboard::Windows;
    }
    when / macos / { 
        require Clipboard::macOS;
    }
    default {
        # Assuming it is Linux and it has xclip
        require Clipboard::Linux;
    }
}

multi sub copy-to-clipboard($payload, :$clipboard-command is copy = Whatever) {

    my $payload2 = $payload;
    if $payload2 !~~ Str {
        $payload2 = $payload2.raku;
    }

    if $clipboard-command.isa(Whatever) || $clipboard-command ~~ Str && $clipboard-command eq 'Whatever' {
        if %*ENV<CLIPBOARD_COPY_COMMAND>:exists {
            $clipboard-command = %*ENV<CLIPBOARD_COPY_COMMAND>;
        } else {
            $clipboard-command =
                    do given $*DISTRO {
                        when $_.is-win { "clip.exe" }
                        when $_ ~~ 'macos' { "pbcopy" }
                        default {
                            # Assuming it is Linux and it has xclip
                            "xclip"
                        }
                    }
        }
    }

    if $clipboard-command.chars > 0 {
        $payload2 .= subst("'", '\x27'):g;
        shell "echo '$payload2' | $clipboard-command";
    }
    return $payload;
}

multi sub copy-to-clipboard(Bool :$usage-message = True -->Str) {
    my $usage = Q:c:to/EOH/;
        If --clipboard-command is the empty string then no copying to the clipboard is done.
        If --clipboard-command is 'Whatever' then:
            1. It is attempted to use the environment variable CLIPBOARD_COPY_COMMAND.
                If CLIPBOARD_COPY_COMMAND is defined and it is the empty string then no copying to the clipboard is done.
            2. If the variable CLIPBOARD_COPY_COMMAND is not defined then:
                - 'pbcopy' is used on macOS
                - 'clip.exe' on Windows
                - 'xclip -sel clip' on Linux.
    EOH

    if $usage-message {
        $usage
    } else {
        warn 'No reason to use this function signature with !$usage-message.'
    }
}

#===========================================================
# Paste
#===========================================================

proto paste(|) is export(:DEFAULT, :ALL) {*}

multi sub paste(:$clipboard-command is copy = Whatever) {

    if $clipboard-command.isa(Whatever) || $clipboard-command ~~ Str && $clipboard-command eq 'Whatever' {
        if %*ENV<CLIPBOARD_PASTE_COMMAND>:exists {
            $clipboard-command = %*ENV<CLIPBOARD_PASTE_COMMAND>;
        } else {
            $clipboard-command =
                    do given $*DISTRO {
                        when $_.is-win { "clip.exe" }
                        when $_ ~~ 'macos' { "pbpaste" }
                        default {
                            # Assuming it is Linux and it has xclip
                            "xclip -o"
                        }
                    }
        }
    }

    if $clipboard-command.chars > 0 {
        my $proc = Proc.new(:out);
        $proc.shell("$clipboard-command");
        my $captured-output = $proc.out.slurp: :close;
        return $captured-output;
    }
    return Nil;
}

#===========================================================
# Paste
#===========================================================

#| Synonym of copy-to-clipboard
constant &cbcopy is export(:ALL, :cb-prefixed) = &copy-to-clipboard;

#| Synonym to paste
constant &cbpaste is export(:ALL, :cb-prefixed) = &paste;

#| Synonym to paste
constant &paste-from-clipboard is export(:ALL, :long-names) = &paste;
