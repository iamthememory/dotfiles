#!/usr/bin/env perl

use v5.18;
use strict;
use warnings;

use Parse::nm;
use Data::Dumper;
use Set::Light;

my %defsyms;

my @sects;


# First, map all defined symbols to their respective libraries.

foreach my $lib (@ARGV) {
    say "Getting defined symbols from $lib...";

    Parse::nm->run(
        options => [ qw(--defined-only) ],
        filters => [
            {
                action => sub {
                    if (exists $defsyms{$_[0]}) {
                        $defsyms{$_[0]}->insert($lib)
                    } else {
                        $defsyms{$_[0]} = Set::Light->new(($lib));
                    }
                }
            }
        ],
        files => $lib
    );
}

say '';


# Check for duplicates.
my @lines = ();
foreach my $sym (keys %defsyms) {
    if ($defsyms{$sym}->size() > 1) {
        my @libs = ("Multiple files for symbol $sym:");

        foreach my $lib (sort(keys %{${defsyms{$sym}}})) {
            push @libs, "  - $lib"
        }

        push @lines, join("\n", @libs)
    }
}

if (scalar @lines) {
    push @sects, join("\n\n", @lines);
}


# Now, find all undefined symbols.

@lines = ();
my @graphlines = ("digraph {");

foreach my $lib (sort @ARGV) {
    say "Getting undefined symbols from $lib...";

    my $deps = new Set::Light;

    my @dlines = ("Dependencies for library $lib:");

    Parse::nm->run(
        options => [ qw(--undefined-only) ],
        filters => [
            {
                action => sub {
                    if (exists $defsyms{$_[0]}) {
                        $deps->insert(keys %{$defsyms{$_[0]}});
                    } else {
                        #say "No library for symbol $_[0]";
                    }
                }
            }
        ],
        files => $lib
    );

    # Having undefined symbols from ourself is common.
    # Ignore them.
    $deps->delete($lib);

    foreach my $dep (sort keys %$deps) {
        push @dlines, "  - $dep"
    }

    push @lines, join("\n", @dlines);

    my $gdeps = join(" ", map {s/.*/\"$&\"/r} sort keys %$deps);

    push @graphlines, "  \"$lib\" -> {$gdeps}"
}

say '';

push @graphlines, "}";


if (scalar @lines) {
    push @sects, join("\n\n", @lines);
}


if (scalar @graphlines) {
    push @sects, join("\n", @graphlines);
}


# Print our results!
say join("\n\n", @sects)
