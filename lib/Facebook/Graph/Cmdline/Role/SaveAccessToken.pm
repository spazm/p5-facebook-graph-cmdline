package Facebook::Graph::Cmdline::Role::SaveAccessToken;

#ABSTRACT: Provides a save_access_token method to save token value to YAML config file.

use v5.10;
use Any::Moose 'Role';
use YAML::Any;

requires qw( get_config_from_file configfile access_token );

# MooseX::SimpleConfig or MouseX::SimpleConfig will provide
# both get_config_from_file and configfile

=method save_access_token

Updates token value in configfile and saves as YAML if modified.

If configfile is not defined, the token is printed to STDOUT for manual saving.

=cut

sub save_access_token
{
    my $self = shift;
    if ( !$self->configfile )
    {
        say "please save token: " . $self->access_token;
        return 1;
    }

    my $config = $self->get_config_from_file( $self->configfile );
    if ( !exists $config->{access_token}
        or $self->access_token ne $config->{access_token} )
    {
        $config->{access_token} = $self->access_token;
        YAML::Any::DumpFile( $self->configfile, $config );
    }
}

1;
