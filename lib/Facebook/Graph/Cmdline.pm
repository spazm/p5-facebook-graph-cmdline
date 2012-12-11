package Facebook::Graph::Cmdline;

#ABSTRACT: Extends Facebook::Graph with embedded HTTP for Oauth and token saving

use Any::Moose;
use v5.10;

extends 'Facebook::Graph';
with 'Facebook::Graph::role::HTTPtoken';

#Is there a better way to do MooseX vs MouseX 'with' loading?
#can import with "use Any::Moose 'X::SimpleConfig'" but that doesn't
#provide the action of "with," Mo*se::Util::apply_all_roles()
if (Any::Moose::moose_is_preferred)
{
    with 'MooseX::SimpleConfig';
    with 'MooseX::Getopt';
}
else
{
    with 'MouseX::SimpleConfig';
    with 'MouseX::Getopt';
}
# requires provided by ::SimpleConfig
with 'Facebook::Graph::role::save_token';

no Any::Moose;
__PACKAGE__->meta->make_immutable;
