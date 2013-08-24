soundcloud-cli-ruby
===================

Soundcloud Command-Line Interface in Ruby


Authentication
======

Soundcloud API requires OAuth for all of its functionality, so you'll need a registered Soundcloud application. If you've never registered a Soundcloud application before, it's easy! Just sign-in using your Soundcloud account and the fill out the short form at http://soundcloud.com/you/apps. If you've previously registered a Soundcloud application, it should be listed at http://soundcloud.com/you/apps.

On your first use of sc-cli, you will be prompted to enter the Client ID, Client Secret, your username and your password.  These will all be sent **directly** to Soundcloud which will provide an `access_token`.  The `access_token` will be written to `$HOME/.sc-cli`.

*Note*: Anyone with access to this file can impersonate you on Soundcloud, so it's important to keep it secure, just as you would treat your SSH private key.


Thanks
===

Some of the authentication documentation was derrived from the documentation of the `t` ruby gem.
