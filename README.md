soundcloud-cli-ruby
===================

Soundcloud Command-Line Interface in Ruby

It lets you do cool things like search for tracks and create a playlist from the results:

  `sc s tracks -q awsome --fields=id | sc set create --title="My awesome set"`


Help
===

You can always pass `-h` or `--help` to print the help for the current command.  In this way, the entire CLI is discoverable.  Expanded documentation and tips are provided below.

Authentication
======

Soundcloud API requires OAuth for all of its functionality, so you'll need a registered Soundcloud application. If you've never registered a Soundcloud application before, it's easy! Just sign-in using your Soundcloud account and the fill out the short form at http://soundcloud.com/you/apps. If you've previously registered a Soundcloud application, it should be listed at http://soundcloud.com/you/apps.

On your first use of sc-cli, you will be prompted to enter the Client ID, Client Secret, your username and your password.  These will all be sent **directly** to Soundcloud which will provide an `access_token`.  The `access_token` will be written to `$HOME/.sc-cli`.

*Note*: Anyone with access to this file can impersonate you on Soundcloud, so it's important to keep it secure, just as you would treat your SSH private key.


Search
====

```
name
    search - searches the Soundcloud API
    aliases: s

usage
    sc search [type] [options]

subcommands
    groups        searches for groups
    playlists     searches for playlists
    tracks        searches for tracks
    users         searches for users

options
    -h --help    show help for this command

options for sc
    -h --help    show help for this command


````

For most of the searches, you can just `sc search [type] -q [query]`

Example:

```
$ sc search users -q aaronblohowiak
http://soundcloud.com/aaronblohowiak

```

By default, the `permalink_url` of the matched items will be printed with one url per line.  You can change the field or have multiple fields printed by passing them like `--fields=avatar_url,permalink_url`. If you just want the full json response, use the `--json` flag.  For pagination, use the `--limit` and `--offset` parameters.


Here's the output for `sc search tracks -h`:


```
name
    tracks - searches for tracks

usage
    sc search tracks [options]

options
    -bf --bpm[from]           return tracks with at least this bpm value
    -bt --bpm[to]             return tracks with at least this bpm value
    -cf --created_at[from]    (yyyy-mm-dd hh:mm:ss) return tracks created at this date or later
    -ct --created_at[to]      (yyyy-mm-dd hh:mm:ss) return tracks created at this date or earlier
    -df --duration[from]      return tracks with at least this duration (in millis)
    -dt --duration[to]        return tracks with at most this duration (in millis)
    -  --fields              the fields to output as csv. Default: permalink_url
    -f --filter              One of: all,public,private,streamable,downloadable
    -g --genres              a comma separated list of genres
    -h --help                show help for this command
    -i --ids                 a comma separated list of track ids to filter on
    -  --json                Output the full response as json.
    -l --license             One of: no-rights-reserved,all-rights-reserved,cc-by,cc-by-sa,cc-by-nd,cc-by-nc,cc-by-nc-nd
    -  --limit               the number of results to return. 50 by default, max 200
    -  --offset              the number of results to skip. 0 by default, max 8000
    -q --q                   search term
    -t --tags                comma separated list of tags
    -ty --types               a comma separated list of types

options for search
    -h --help                show help for this command
    -h --help                show help for this command

```


Playlists / Sets
===
`sc` is most useful for creating and deleting playlists.  You can create a playlist by passing the track ids either as a comma-separated list OR by providing a newline-delimited list to STDIN.  This lets you create playlists as part of a pipeline.

  `sc s tracks -q awsome --fields=id | sc set create --title="My awesome set"`

```
name
    create - creates a new playlist

usage
    sc playlist create [options]

description
    accepts track ids as a comma-separated list option or as a newline-separated
    list from STDIN.

options
    -  --fields     the fields to output as csv. Default: permalink_url
    -h --help       show help for this command
    -  --json       Output the full response as json.
    -s --sharing    sharing options for your playlist. One of public,private.
    -t --title      the title for your playlist
    -ids --tracks     comma-separated list of track ids.

options for playlist
    -h --help       show help for this command
    -h --help       show help for this command

```

There are several other features as well:


```
name
    playlist - uses the Soundcloud API to get and modify playlists
    aliases: set p playlists

usage
    sc playlist [action] [options]

subcommands
    create     creates a new playlist
    delete     deletes a playlist by id
    get        Retrieve information about a playlist

options
    -h --help    show help for this command

options for sc
    -h --help    show help for this command

```


Thanks
===

Some of the authentication documentation was derrived from the documentation of the `t` ruby gem.
