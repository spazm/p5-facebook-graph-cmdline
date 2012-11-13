package Facebook::Graph::Cmdline;

#ABSTRACT: Authorization handling for Commandline Facebook apps

use v5.10;
use Any::Moose;
extends 'Facebook::Graph' => { -version => 1.0401 };

use HTTP::Daemon 6.00;
use Data::Dumper;

has postback_host => (
    is      => 'ro',
    default => 'localhost',
);
has postback_port => (
    is      => 'ro',
    default => '8123',
);
has postback_path => (
    is      => 'ro',
    default => '/',
);
has postback => (
    is => 'ro',
    lazy_build => 1
);
sub _build_postback
{
    my $self = shift;
    sprintf("http://%s:%s%s",
        $self->postback_host,
        $self->postback_port,
        $self->postback_path
    );
}
has code => (
    is => 'rw',
    lazy_build => 1,
);
has token => (
    is => 'rw',
    lazy_build => 1,
);
has permissions => (
    is      => 'ro',
    default => sub {
        [   qw(
                email
                offline_access
                publish_stream
                publish_actions
                create_event
                rsvp_event
                manage_pages
                user_groups)
        ];
    }
);

sub _build_code
{
    my $self = shift;
    my $uri = $self
        ->authorize
        ->extend_permissions( @{$self->permissions} )
        ->uri_as_string;
    say "Please visit this url to authorize app:\n$uri";

    use HTTP::Daemon;
    my $d = HTTP::Daemon->new(
            LocalAddr => $self->postback_host,
            LocalPort => $self->postback_port)
        || die;
    say "url: " . $d->url;

    my $code = '';
    until($code)
    {
        my $c = $d->accept;
        my $r = $c->get_request;
        next unless $r;

        if ($r->url->path eq $self->postback_path and
            $r->url->query_param('code'))
        {
            $code = $r->url->query_param('code');
            $c->send_response( HTTP::Response->new( 200,undef,undef, "success!" ) );
        }
        else
        {
            $c->send_error('500');
        }
    }
    say "success: got code: $code";
    $code
}

sub _build_token
{
    my $self = shift;
    my $resp = $self->request_access_token($self->code);
    my $token = $resp->token;
    say Dumper { token => $token, expires => $resp->expires };
    $token;
}

sub verify_token
{
    my $self = shift;

    say "verifying token";
    $self->access_token($self->token);
    my $resp;
    eval { $resp = $self->fetch('me') };
    if ($@) {
        say "problem with access token, let's get new one";
        print Dumper { resp => $resp };
        $self->clear_token;
        return 0;
    }
    return 1;
}
sub verify_code
{
    #TODO: try and request something with the code and see if it works?
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
