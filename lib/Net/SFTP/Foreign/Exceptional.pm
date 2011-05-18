package Net::SFTP::Foreign::Exceptional;

# ABSTRACT: wraps Net::SFTP::Foreign to throw exceptions on failure

use English '-no_match_vars';
use Moose;
use Class::Inspector;
use Net::SFTP::Foreign 1.65;
use Readonly;

Readonly my $WRAPPED => 'Net::SFTP::Foreign';
Readonly my @METHODS => Class::Inspector->methods( $WRAPPED, 'public' );

=attr ERROR

Contains the error code of the most recent action.

=cut

has ERROR => ( is => 'ro', writer => '_set_ERROR' );
has _sftp => ( is => 'ro', isa => $WRAPPED, handles => \@METHODS );

around BUILDARGS => sub {
    my ( $orig, $class ) = splice @ARG, 0, 2;
    my $sftp = Net::SFTP::Foreign->new(@ARG);
    $sftp->die_on_error();

    return $class->$orig( _sftp => $sftp );
};

after \@METHODS => sub {
    my $self = shift;
    my $sftp = $self->_sftp;
    $self->_set_ERROR( $sftp->error );
    $sftp->die_on_error();
};

__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    my $sftp;
    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1 }
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Wrapper around L<Net::SFTP::Foreign|Net::SFTP::Foreign> that delegates all
public method calls to it, throwing exceptions instead of merely returning
C<undef>.
