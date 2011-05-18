package Net::SFTP::Foreign::Exceptional;

# ABSTRACT: wraps Net::SFTP::Foreign to throw exceptions on failure

use strict;
use warnings;

use Net::SFTP::Foreign;

use Carp;
our @CARP_NOT = qw(Net::SFTP::Foreign);

our $ERROR = 0;

sub new {
    my $class = shift;
    my $sftp = Net::SFTP::Foreign->new(@_);
    my $self = \$sftp;
    bless $self, $class;
    $ERROR = $sftp->error and $sftp->die_on_error;
    $self;
}

sub DESTROY {}

our $AUTOLOAD;
sub AUTOLOAD {
    my $method_name = $AUTOLOAD;
    $method_name =~ s/.*:://;

    Net::SFTP::Foreign->can($method_name)
        or croak qq(Can't locate object method "$method_name" via package "Net::SFTP::Foreign::Exceptional");

    my $sub = sub {
        my $sftp = ${shift @_};
        if (wantarray) {
            my @r = $sftp->$method_name(@_);
            $ERROR = $sftp->error and $sftp->die_on_error;
            return @r;
        }
        else {
            my $r = $sftp->$method_name(@_);
            $ERROR = $sftp->error and $sftp->die_on_error;
            return $r;
        }
    };
    {
        no strict 'refs';
        *$method_name = $sub;
    }
    goto &$sub;
}

1;

__END__

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    my $sftp;
    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1}
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Subclass of L<Net::SFTP::Foreign|Net::SFTP::Foreign> that wraps many of its
methods to throw exceptions instead of merely returning C<undef>.  Any methods
not listed here simply call the superclass.

