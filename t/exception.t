#!perl

use 5.008;
use strict;
use warnings;
use utf8;

use Test::Most tests => 1;
use Net::SFTP::Foreign::Exceptional;

dies_ok(
    sub { Net::SFTP::Foreign::Exceptional->new('sftp.invalid') },
    'invalid connection dies OK',
);
