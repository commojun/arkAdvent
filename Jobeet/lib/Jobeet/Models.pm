package Jobeet::Models;
use strict;
use warnings;
use Cache::FastMmap;
use Ark::Models '-base';

register Schema => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{database}
        or die 'require database config';

    $self->ensure_class_loaded('Jobeet::Schema');
    Jobeet::Schema->connect(@$conf);
};


autoloader qr/^Schema::/ => sub {
    my ($self, $name) = @_;

    my $schema = $self->get('Schema');
    for my $t ($schema->sources) {
        $self->register( "Schema::$t" => sub { $schema->resultset($t) });
    }
};


register cache => sub {
    my $self = shift;

    my $conf = $self->get('conf')->{cache}
        or die 'require cache config';

    $self->ensure_class_loaded('Cache::FastMmap');
    Cache::FastMmap->new(%$conf);
};

1;
