package Net::SFTP::Foreign::Exceptional;

# ABSTRACT: wraps Net::SFTP::Foreign to throw exceptions on failure

use Carp;
use English '-no_match_vars';
use Moose;
use MooseX::NonMoose;
extends 'Net::SFTP::Foreign';

=method BUILD

After C<new()>, an exception will be thrown if there was a connection failure.

=cut

sub BUILD {
    my ( $self, $args_ref ) = @ARG;
    $self->die_on_error("SSH connection to $args_ref->{host} failed");
    return;
}

=method cwd

=method setcwd

=method get

=method get_content

=method get_symlink

=method put

=method put_symlink

=method ls

=method find

=method glob

=method rget

=method rput

=method rremove

=method mget

=method mput

=method open

=method close

=method read

=method write

=method readline

=method getc

=method seek

=method tell

=method eof

=method flush

=method sftpread

=method sftpwrite

=method opendir

=method closedir

=method readdir

=method stat

=method fstat

=method lstat

=method setstat

=method fsetstat

=method remove

=method mkdir

=method mkpath

=method rmdir

=method rename

=method atomic_rename

=method readlink

=method symlink

=method hardlink

=method statvs

=method fstatvs

=cut

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
    croak 'SFTP error: ' . $self->error if !defined $result;
    return $result;
    };

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=head1 SYNOPSIS

    use Net::SFTP::Foreign::Exceptional;

    eval { $sftp = Net::SFTP::Foreign::Exceptional->new(host => 'sftp.example.com'); 1}
        or print "SFTP exception: $@\n";

=head1 DESCRIPTION

Subclass of L<Net::SFTP::Foreign|Net::SFTP::Foreign> that wraps many of its
methods to throw exceptions instead of merely returning C<undef>.  Any methods
not listed here simply call the superclass.

