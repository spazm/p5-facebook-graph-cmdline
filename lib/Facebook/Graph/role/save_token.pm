package Facebook::Graph::role::save_token;

#ABSTRACT: Provides a save_token method to save token value to YAML config file.

use v5.10;
use Any::Moose 'Role';
use YAML::Any;

requires qw( get_config_from_file configfile token );
# MooseX::SimpleConfig or MouseX::SimpleConfig will provide
# both get_config_from_file and configfile

=method save_token

Updates token value in configfile and saves as YAML if modified.

If configfile is not defined, the token is printed to STDOUT for manual saving.

=cut

sub save_token
{
    my $self = shift;
    if ( !$self->configfile )
    {
        say "please save token: " . $self->token;
        return 1;
    }

    my $config = $self->get_config_from_file( $self->configfile );
    if ( !exists $config->{token} or $self->token ne $config->{token} )
    {
        $config->{token} = $self->token;
        YAML::Any::DumpFile( $self->configfile, $config );
    }
}

1;
