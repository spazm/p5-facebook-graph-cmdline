package Facebook::Graph::Cmdline;

#ABSTRACT: Extends Facebook::Graph to create and save an access token.

use Any::Moose;
use v5.10;

extends 'Facebook::Graph';
with 'Facebook::Graph::role::HTTPtoken';
#Is there a better way to do MooseX vs MouseX 'with' loading?
#can import with "use Any::Moose 'X::SimpleConfig'" but that doesn't
#provide the action of "with," Mo*se::Util::apply_all_roles()
if (Any::Moose::moose_is_preferred) {
    with 'MooseX::SimpleConfig';
    with 'MooseX::Getopt';
}
else
{
    with 'MouseX::SimpleConfig';
    with 'MouseX::Getopt';
}

=method save_token

Updates token value in configfile and saves as YAML if modified.

If configfile is not defined, the token is printed to STDOUT for manual saving.

=cut

sub save_token {
    my $self = shift;
    if (!$self->configfile)
    {
        say "please save token: " . $self->token ;
        return 1;
    }

    my $config = $self->get_config_from_file( $self->configfile );
    if (!exists $config->{token} or $self->token ne $config->{token})
    {
        $config->{token} = $self->token;
        say "saving updated token!"; ## DEBUG
        use YAML::Any;
        YAML::Any::DumpFile( $self->configfile, $config);
    }
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
