package Net::SFTP::Foreign::Exceptional;

use 5.008;
use strict;
use warnings;
use utf8;

our $VERSION = '0.010';    # VERSION
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

__END__

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=head1 NAME

Net::SFTP::Foreign::Exceptional - wraps Net::SFTP::Foreign to throw exceptions on failure

=head1 VERSION

version 0.010

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    my $sftp;
    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1 }
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Wrapper around L<Net::SFTP::Foreign|Net::SFTP::Foreign> that delegates all
public method calls to it, throwing exceptions instead of merely returning
C<undef>.

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Net::SFTP::Foreign::Exceptional

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/Net-SFTP-Foreign-Exceptional>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annonations of Perl module documentation.

L<http://annocpan.org/dist/Net-SFTP-Foreign-Exceptional>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Net-SFTP-Foreign-Exceptional>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/Net-SFTP-Foreign-Exceptional>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/N/Net-SFTP-Foreign-Exceptional>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual way to determine what Perls/platforms PASSed for a distribution.

L<http://matrix.cpantesters.org/?dist=Net-SFTP-Foreign-Exceptional>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Net::SFTP::Foreign::Exceptional>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at L<https://github.com/mjgardner/net-sftp-foreign-exceptional/issues>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/net-sftp-foreign-exceptional>

  git clone git://github.com/mjgardner/net-sftp-foreign-exceptional.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
