#
# This file is part of Net-SFTP-Foreign-Exceptional
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package Net::SFTP::Foreign::Exceptional;

BEGIN {
    $Net::SFTP::Foreign::Exceptional::VERSION = '0.001';
}

# ABSTRACT: wraps Net::SFTP::Foreign to throw exceptions on failure

use Carp;
use English '-no_match_vars';
use Moose;
use MooseX::NonMoose;
extends 'Net::SFTP::Foreign';

sub BUILD {
    my ( $self, $args_ref ) = @ARG;
    $self->die_on_error("SSH connection to $args_ref->{host} failed");
    return;
}

around [
    qw(
        cwd setcwd get get_content get_symlink put put_symlink
        ls find glob rget rput rremove mget mput
        open close read write readline getc seek tell eof flush
        sftpread sftpwrite opendir closedir readdir
        stat fstat lstat setstat fsetstat
        remove mkdir mkpath rmdir rename atomic_rename
        readlink symlink hardlink
        statvfs fstatvfs
        )
    ] => sub {
    my ( $orig, $self ) = splice @ARG, 0, 2;
    my $result = $self->$orig(@ARG);

    # TODO: replace with exception object
    ## no critic (ErrorHandling::RequireUseOfExceptions)
    croak 'SFTP error: ' . $self->error if !defined $result;

    return $result;
    };

no Moose;
__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

Net::SFTP::Foreign::Exceptional - wraps Net::SFTP::Foreign to throw exceptions on failure

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    my $sftp;
    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1}
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Subclass of L<Net::SFTP::Foreign|Net::SFTP::Foreign> that wraps many of its
methods to throw exceptions instead of merely returning C<undef>.  Any methods
not listed here simply call the superclass.

=head1 METHODS

=head2 BUILD

After C<new()>, an exception will be thrown if there was a connection failure.

=head2 cwd

=head2 setcwd

=head2 get

=head2 get_content

=head2 get_symlink

=head2 put

=head2 put_symlink

=head2 ls

=head2 find

=head2 glob

=head2 rget

=head2 rput

=head2 rremove

=head2 mget

=head2 mput

=head2 open

=head2 close

=head2 read

=head2 write

=head2 readline

=head2 getc

=head2 seek

=head2 tell

=head2 eof

=head2 flush

=head2 sftpread

=head2 sftpwrite

=head2 opendir

=head2 closedir

=head2 readdir

=head2 stat

=head2 fstat

=head2 lstat

=head2 setstat

=head2 fsetstat

=head2 remove

=head2 mkdir

=head2 mkpath

=head2 rmdir

=head2 rename

=head2 atomic_rename

=head2 readlink

=head2 symlink

=head2 hardlink

=head2 statvs

=head2 fstatvs

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

__END__
