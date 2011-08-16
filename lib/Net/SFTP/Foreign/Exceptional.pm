package Net::SFTP::Foreign::Exceptional;

use 5.008;
use strict;
use warnings;
use utf8;

# VERSION
use Carp;
use English '-no_match_vars';
use Any::Moose;
use Net::SFTP::Foreign 1.65;

our @CARP_NOT
    = qw(Net::SFTP::Foreign Class::MOP::Method::Wrapped Mouse::Meta::Class);
my @METHODS = grep { $ARG ne 'new' and $ARG ne 'DESTROY' }
    map { $ARG->name }
    any_moose('::Meta::Class')->initialize('Net::SFTP::Foreign')
    ->get_all_methods();

has _sftp =>
    ( is => 'ro', isa => 'Net::SFTP::Foreign', handles => \@METHODS );
after \@METHODS => sub { shift->_sftp->die_on_error() };

around BUILDARGS => sub {
    my ( $orig, $class ) = splice @ARG, 0, 2;
    my $sftp = Net::SFTP::Foreign->new(@ARG);
    $sftp->die_on_error();
    return $class->$orig( _sftp => $sftp );
};

__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: wraps Net::SFTP::Foreign to throw exceptions on failure

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    my $sftp;
    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1 }
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Wrapper around L<Net::SFTP::Foreign|Net::SFTP::Foreign> that delegates all
public method calls to it, throwing exceptions instead of merely returning
C<undef>.
