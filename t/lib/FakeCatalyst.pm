package FakeCatalyst;

use Moose;
use v5.14;

has config => (
    is => 'ro',
    isa => 'Maybe[HashRef]'
);

sub model {
    my $self = shift;
    return $self->config->{shift()};
}

sub log {
    return FakeLog->new;
}

package FakeLog;

use Moose;

sub debug { shift; say "# $_" for @_ }
sub error { shift; say "# $_" for @_ }
sub warn { shift; say "# $_" for @_ }
sub info { shift; say "# $_" for @_ }
sub fatal { shift; say "# $_" for @_ }

1;
