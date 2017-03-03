#!perl

use strict;
use warnings;

use v5.14;
use lib 'lib';

use Catalyst::Plugin::Model::Duplicate;
use FakeCatalyst;
use Test::Most;

my $c = FakeCatalyst->new( config => {
    'Model::Duplicate' => {
        'This' => 'SharedDB',
        'That::Plugin' => 'SharedDB'
    },
    'Model::SharedDB' => "This is the shared DB",
    'Model::This'     => "This is this model",
    'Model::That::Plugin' => "This is that plugin's model",
    'Model::Another::Plugin' => "This is another plugin's model",
});

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'This' ),
    'SharedDB',
    "This model should be the SharedDB" );

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'That::Plugin' ),
    'SharedDB',
    "That Plugin's model should be the SharedDB" );

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'Another::Plugin' ),
    'Another::Plugin',
    "Another Plugin's model should be its own" );

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'This::ResultClass' ),
    'SharedDB::ResultClass',
    "Sub-namespaces stay the same (1)" );

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'That::Plugin::ResultClass' ),
    'SharedDB::ResultClass',
    "Sub-namespaces stay the same (2)" );

is ( Catalyst::Plugin::Model::Duplicate::_replace_with_aliased( $c, 'Another::Plugin::ResultClass' ),
    'Another::Plugin::ResultClass',
    "Sub-namespaces stay the same (3)" );

