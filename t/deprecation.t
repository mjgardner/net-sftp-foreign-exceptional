#!perl

use 5.008;
use strict;
use warnings;
use utf8;

use Test::Most tests => 1;
use Net::SFTP::Foreign::Exceptional;

warning_is(
    sub {
        eval { Net::SFTP::Foreign::Exceptional->new('sftp.invalid') };
    },
    { carped => $Net::SFTP::Foreign::Exceptional::DEPRECATION },
    'deprecation warning OK',
);
