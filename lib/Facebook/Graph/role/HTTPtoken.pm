package Facebook::Graph::role::HTTPtoken;

#ABSTRACT: Embeds an HTTP::Daemon to implement OAuth callback for Facebook Authorization of Commandline Facebook apps.

use v5.10;
use Any::Moose 'Role';

#all provided by Facebook::Graph
requires qw(
    access_token
    authorize
    fetch
    postback
    request_access_token
);

=attr postback

Contains the URL (a L<URI> object) used for making the authentication
"postback" (an HTTP GET request).

=cut

has +postback => ( is => 'ro', required => 1 );

use HTTP::Daemon 6.00;
use URI;

###
# provides code, token
# requires permissions
# can override prompt_message, success_message

=attr code

Contains the authorization code that is returned once the Facebook app
is successfully authorized during the postback.

=cut

has code => (
    is         => 'rw',
    lazy_build => 1,
);

=attr token

Contains the token string returned while getting the value for L</code>.

=cut

has token => (
    is         => 'rw',
    lazy_build => 1,
);

=attr permissions

An arrayref containing the app's requested permissions.  A list of
possible values is available in the L<Facebook API Reference (Login)|https://developers.facebook.com/docs/reference/login/#permissions>.

=cut

has permissions => (
    is      => 'ro',
    default => sub { [] }
);

# fmt will be called with url as arg
has prompt_message_fmt => (
    is      => 'rw',
    default => "Please visit this url to authorize application:\n%s\n"
);

=attr success_message

Contains the text to be put in the content of a 200 HTTP response that
is generated when L</code> is defined at run time.

=cut

has success_message => (
    is      => 'rw',
    default => 'Success!'
);

sub _build_code
{
    my $self = shift;
    my $uri  = $self
        ->authorize
        ->extend_permissions( @{ $self->permissions } )
        ->uri_as_string;
    printf $self->prompt_message_fmt, $uri;

    use HTTP::Daemon;
    my $postback = URI->new( $self->postback );
    my $d        = HTTP::Daemon->new(
        LocalAddr => $postback->host,
        LocalPort => $postback->port,
    ) || die;

    my $code = '';
    until ($code)
    {
        my $c = $d->accept;
        my $r = $c->get_request;
        next unless $r;

        if (    $r->url->path eq $postback->path
            and $r->url->query_param('code') )
        {
            $code = $r->url->query_param('code');
            $c->send_response(
                HTTP::Response->new(
                    200, undef, undef, $self->success_message
                )
            );
        }
        else
        {
            $c->send_response('204');
        }
    }
    $code;
}

sub _build_token
{
    my $self = shift;
    return $self->request_access_token( $self->code )->token;
}

sub verify_token
{
    my $self = shift;
    return 0 unless $self->has_token();

    say "verifying token";    ## DEBUG
    $self->access_token( $self->token );
    my $resp;
    eval { $resp = $self->fetch('me') };
    if ($@)
    {
        say "Bad access token, deleting";    ## INFO
        $self->clear_token;
        return 0;
    }
    return 1;
}

1;
