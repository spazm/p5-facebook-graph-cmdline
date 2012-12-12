#!/usr/bin/perl

#ABSTRACT: Example Demonstrating Facebook::Graph::Cmdline life cycle

# show_group_information.pl:
#  Demonstrates Facebook::Graph::Cmdline life cycle
#
#  Initializes Facebook::Graph::Cmdline from a yaml
#  configfile(facebook.yml), creates and saves an
#  access token, requests and prints information
#  about a group (LA Perl Mongers)

use warnings;
use strict;
use v5.10.0;

use Data::Dumper;
use Facebook::Graph::Cmdline;
my $fb = Facebook::Graph::Cmdline->new_with_config(
    configfile => 'facebook.yml' );

unless ( $fb->verify_token() )
{
    my $token = $fb->token();
    $fb->save_token();
}

my $lapm_group_id = '119158178096277';
my $events = $fb->fetch("$lapm_group_id/events");

#More info on the first event returned from search
my $next_event_id = $events->{data}[0]->{id};
my $next_event = $fb->fetch($next_event_id);
say "Details:";
say "$_ : $next_event->{$_}" for qw( name start_time location description );
for my $rsvp qw(attending maybe declined)
{
    my $reply = $fb->fetch("$next_event_id/$rsvp")->{data};
    say "$rsvp: ", scalar @$reply;
    say "\t$_->{name}" for @$reply;
}
