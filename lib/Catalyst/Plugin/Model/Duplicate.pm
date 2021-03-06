use strict;
use warnings;
package Catalyst::Plugin::Model::Duplicate;

use Moose;
use namespace::clean -except => 'meta';
use MRO::Compat;
use Safe::Isa;

use v5.14;


our $VERSION = '0.001';

sub model
{
    my ($c, $name, @args) = @_;
    my $appclass = ref($c) || $c;

    $name = _replace_with_aliased($c, $name);

    return $c->next::method($name, @args);
}

sub _replace_with_aliased
{
    my ($c, $name) = @_;

    if( $name ) {
        # this module isn't going to deal with regex lookup.
        unless ( $name->$_isa('Regexp') ) {
            my $orig = $name;
            for my $alias ( keys %{ $c->config->{'Model::Duplicate'} } ) {
                my $alt = $c->config->{'Model::Duplicate'}->{$alias};
                if ($name =~ s/^\Q$alias\E/$alt/) {
                    $c->log->debug("$orig matched $alias; using $name");
                    return $name;
                }
            }
        }
    }

    $name;
}

__PACKAGE__->meta->make_immutable;
1;


# ABSTRACT: allow models to be duplicated/aliased

=head1 DESCRIPTION

This module allows the same model to be referenced by multiple names.

With a config like this,

    <Model::Duplicate>
        SomeDB      MainDB
        AnotherDB   MainDB
    </Model::Duplicate>

Calls to SomeDB will actually go to MainDB.  For example,

    my $rs = $c->model('SomeDB::MyRS');

Will actually effectively call return C<MainDB::MyRS> instead.

If this sounds crazy or of no use to you, that's fine.  It's
most useful when you have lots of simple units for a database
composed across multiple modules.  This way you can merge them
up and use them as a single database, but still have code
that references the models as if they only knew about the single
part.

If you actually have multiple model objects then you end up
with a database connection being maintained per model, which
is wasteful when you're talking to the one database.

=head1 METHODS

=head2 model

This plugin overrides Catalyst's C<model> method to allow the
models to be aliased.

This won't do anything with Regexp model lookups.  It will
only try to alias string lookups.

=cut
