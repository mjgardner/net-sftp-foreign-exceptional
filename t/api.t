#!perl

use English '-no_match_vars';
use Test::Most tests => 1;
use Moose ();
use Net::SFTP::Foreign;
use Net::SFTP::Foreign::Exceptional;

cmp_deeply( [ method_names('Net::SFTP::Foreign::Exceptional') ],
    superbagof( method_names('Net::SFTP::Foreign') ), 'methods' );

sub method_names {
    map { $ARG->name }
        Moose::Meta::Class->initialize( $ARG[0] )->get_all_methods();
}
