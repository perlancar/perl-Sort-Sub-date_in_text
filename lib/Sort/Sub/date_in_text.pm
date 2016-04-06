package Sort::Sub::date_in_text;

# DATE
# VERSION

use 5.010;
use strict;
use warnings;

use Date::Extract;
use DateTime;

my $parser = Date::Extract->new;

sub gen_sorter {
    my ($is_reverse, $is_ci) = @_;

    my $re_is_num = qr/\A
                       [+-]?
                       (?:\d+|\d*(?:\.\d*)?)
                       (?:[Ee][+-]?\d+)?
                       \z/x;

    sub {
        no strict 'refs';

        my $caller = caller();
        my $a = @_ ? $_[0] : ${"$caller\::a"};
        my $b = @_ ? $_[1] : ${"$caller\::b"};

        my $cmp;

        # XXX cache

        my $dt_a = $parser->extract($a);
        my $dt_b = $parser->extract($b);

        {
            if ($dt_a && $dt_b) {
                $cmp = DateTime->compare($dt1, $dt2);
                last if $cmp;
            } elsif ($dt_a && !$dt_b) {
                $cmp = -1;
                last;
            } elsif (!$dt_a && $dt_b) {
                $cmp = 1;
                last;
            }

            if ($ci) {
                $cmp = lc($a) cmp lc($b);
            } else {
                $cmp = $a cmp $b;
            }
        }

        $is_reverse ? -1*$cmp : $cmp;
    };
}

1;
# ABSTRACT: Sort by date found in text or (if no date is found) ascibetically

=for Pod::Coverage ^(gen_sorter)$

=head1 DESCRIPTION

The generated sort routine will sort by date found in text (extracted using
L<Date::Extract>) or (f no date is found in text) ascibetically. Items that have
a date will sort before items that do not.

=head1 SEE ALSO
