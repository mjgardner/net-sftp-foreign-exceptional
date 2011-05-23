#!perl
#
# This file is part of Net-SFTP-Foreign-Exceptional
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.008;
use strict;
use warnings;
use utf8;

use English '-no_match_vars';
use Test::More tests => 2;
use Test::Deep;
use Test::Moose;
use Moose ();
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
        Moose::Meta::Class->initialize( $ARG[0] )->get_all_methods();
}
