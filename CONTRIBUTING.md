suggestions and patches welcome! Thank you in advance.

# THANK YOU

Big thanks to all current and future contributors.  Mad Props to JT Smith for writing Facebook::Graph and spelunking the byzantine documentation of facebook's graph api.

## Helpers:
  * Tommy Stanton: pod docs! yaml clean-up, dzil cleanup, testing, and
    moral support.

# Building from Source

## Checking out sources

````
    # clone from github:
    git clone https://github.com/spazm/p5-facebook-graph-cmdline.git
````

## Installing Author Dependencies
````
    # install cpanm
    cpan App::cpanminus

    # install Dist::Zilla
    cpanm install Dist::Zilla

    # change to the root of the project check out
    cd p5-facebook-graph-cmdline

    #install author dependencies with cpanm (App::cpanminus)
    dzil authordeps | cpanm
````

## Running tests
````
    # build and test:
    dzil test
    # just build
    dzil build
````

# Contributing

## Issue Requests and Bug Tracking
Please file tickets using the github ticketing system:

[Github issues](https://github.com/spazm/p5-facebook-graph-cmdline/issues)

## Patches

Patches of any form may be accepted, they may be edited.  You may email me first or just jump straight to patching.

I prefer code with:

  * tests
  * examples
  * concise testable functions
  * descriptive commit messages

## Making Changes
([borrowed](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md) from the puppet docs)

  * Create a topic branch from where you want to base your work.
  * This is usually the master branch.
  * Only target release branches if you are certain your fix must be on that
    branch.
  * To quickly create a topic branch based on master; `git branch
    fix/master/my_contribution masterbranch.
  * Make commits of logical units.
  * Check for unnecessary whitespace with `git diff --check` before committing.
  * Make sure your commit messages are in proper format:
````
    (#99999) Make the example in CONTRIBUTING imperative and concrete

    Without this patch applied the example commit message in the CONTRIBUTING
    document is not a concrete example.  This is a problem because the
    contributor is left to imagine what the commit message should look like
    based on a description rather than an example.  This patch fixes the
    problem by making the example concrete and imperative.

    The first line is a real life imperative statement with a ticket number
    from our issue tracker.  The body describes the behavior without the patch,
    why this is a problem, and how the patch fixes the problem when applied.
````
  * Make sure you have added the necessary tests for your changes.
  * Run _all_ the tests to assure nothing else was accidentally broken.

## Submitting Changes

  * Push your changes to a topic branch in your fork of the repository
  * Submit a pull request to my repository

### github pull requests

github pull requests are preferred as they are easiest to integrate.  Make a github clone of the project, commit your changes and then file a pull request via the github UI.

### patches
Git can create patches from your local repository.  Use `git-format-patch` to create the patch and mail it to `spazm` _at_ `cpan.org`.

If you're not comfortable with git, mail a unified patch produced by `diff -u`.  Or ask me your git questions, I'm happy to help get you started.

Caveat, I get a lot of spam to my cpan address, so I may not see your patch for a while.  Filing a bug request on github will help.

# Additional Resources
* [General GitHub documentation](http://help.github.com/)
* [GitHub pull request documentation](http://help.github.com/send-pull-requests/)

Thanks again!
