#!perl

use 5.008;
use strict;
use warnings;
use utf8;

use English '-no_match_vars';
use Test::More tests => 2;
use Test::Deep;
use Any::Moose;
BEGIN { eval 'use Test::' . any_moose() }
use Net::SFTP::Foreign;
use Net::SFTP::Foreign::Exceptional;

meta_ok('Net::SFTP::Foreign::Exceptional');
cmp_deeply(
    [ method_names('Net::SFTP::Foreign::Exceptional') ],
    superbagof( method_names('Net::SFTP::Foreign') ),
    'wrapped methods',
);

sub method_names {
    map { $ARG->name }
        any_moose('::Meta::Class')->initialize( $ARG[0] )->get_all_methods();
}
