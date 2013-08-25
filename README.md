soundcloud-cli-ruby
===================

SoundCloud Command-Line Interface in Ruby

It lets you do cool things like search for tracks and create a playlist from the results:

  `sc s tracks -q awsome --fields=id | sc set create --title="My awesome set"`


## Installation

```
git clone git@github.com:aaronblohowiak/soundcloud-cli-ruby.git sc
cd sc
gem build sc.gemspec
gem install *.gem
sc -h
```

Help
===

You can always pass `-h` or `--help` to print the help for the current command.  In this way, the entire CLI is discoverable.  Expanded documentation and tips are provided below.


Authentication
======

SoundCloud API requires OAuth for all of its functionality, so you'll need a registered SoundCloud application. If you've never registered a SoundCloud application before, it's easy! Just sign-in using your SoundCloud account and the fill out the short form at http://soundcloud.com/you/apps. If you've previously registered a SoundCloud application, it should be listed at http://soundcloud.com/you/apps.

On your first use of sc-cli, you will be prompted to enter the Client ID, Client Secret, your username and your password.  These will all be sent **directly** to SoundCloud which will provide an `access_token`.  The `access_token` will be written to `$HOME/.sc-cli`.

*Note*: Anyone with access to this file can impersonate you on SoundCloud, so it's important to keep it secure, just as you would treat your SSH private key.

If you ever need to re-authenticate, you can use `sc authenticate`.

Search
====

```
name
    search - searches the SoundCloud API
    aliases: s

usage
    sc search [type] [options]

subcommands
    groups        searches for groups
    playlists     searches for playlists
    tracks        searches for tracks
    users         searches for users

options for sc
    -h --help    show help for this command


````

For most of the searches, you can just `sc search [type] -q [query]`

Example:

```
$ sc search users -q aaronblohowiak
http://soundcloud.com/aaronblohowiak2
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
    -b --bpm[from]           return tracks with at least this bpm value
    -B --bpm[to]             return tracks with at least this bpm value
    -c --created_at[from]    (yyyy-mm-dd hh:mm:ss) return tracks created at this date or later
    -C --created_at[to]      (yyyy-mm-dd hh:mm:ss) return tracks created at this date or earlier
    -d --duration[from]      return tracks with at least this duration (in millis)
    -D --duration[to]        return tracks with at most this duration (in millis)
    -  --fields              the fields to output as csv. Default: permalink_url
    -f --filter              One of: all,public,private,streamable,downloadable
    -g --genres              a comma separated list of genres
    -i --ids                 a comma separated list of track ids to filter on
    -  --json                Output the full response as json.
    -l --license             One of: no-rights-reserved,all-rights-reserved,cc-by,cc-by-sa,cc-by-nd,cc-by-nc,cc-by-nc-nd
    -  --limit               the number of results to return. 50 by default, max 200
    -  --offset              the number of results to skip. 0 by default, max 8000
    -q --q                   search term
    -t --tags                comma separated list of tags
    -T --types               a comma separated list of types

options for search
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
    -  --json       Output the full response as json.
    -s --sharing    sharing options for your playlist. One of public,private.
    -t --title      the title for your playlist
    -T --tracks     comma-separated list of track ids.

options for playlist
    -h --help       show help for this command

```

There are several other features as well:


```
name
    playlist - uses the SoundCloud API to get and modify playlists
    aliases: set p playlists

usage
    sc playlist [action] [options]

subcommands
    create     creates a new playlist
    delete     deletes a playlist by id
    get        Retrieve information about a playlist

options for sc
    -h --help    show help for this command

```


Uploading Tracks
===

You can easily upload a directory's worth of tracks to soundcloud and create a new playlist.

`sc track upload * --fields=id | sc playlist create --title="new playlist"`

The track titles will be the filenames with their extensions stripped off.  Additionally, you could pass in a list of newline-delimited filenames to the command via STDIN.


```

usage
    sc track upload [options] filename1 filename2 ... filename N

description
    Uploads files to SoundCloud, accepting filenames as ending args or as a
    newline-delimited list via STDIN.

options
    -  --fields     the fields to output as csv. Default: permalink_url
    -  --json       Output the full response as json.
    -s --sharing    public/private sharing. One of: public,private
    -t --title      the Title for the track. Not used if multiple filenames are provided.

options for track
    -h --help       show help for this command

```


Fun
===

Find a track and play it from the command line.

`sc lucky` will play a random track

`sc lucky moombahton` will search for `moombahton` and play back one of the first 20 hits at random.


```
name
    lucky - picks a track at random and plays it using the `open` command.

usage
    sc lucky [options] [search term]

options
    -b --bpm[from]           return tracks with at least this bpm value
    -B --bpm[to]             return tracks with at least this bpm value
    -c --created_at[from]    (yyyy-mm-dd hh:mm:ss) return tracks created at this date or later
    -C --created_at[to]      (yyyy-mm-dd hh:mm:ss) return tracks created at this date or earlier
    -d --duration[from]      return tracks with at least this duration (in millis)
    -D --duration[to]        return tracks with at most this duration (in millis)
    -f --filter              One of: all,public,private,streamable,downloadable
    -g --genres              a comma separated list of genres
    -i --ids                 a comma separated list of track ids to filter on
    -l --license             One of: no-rights-reserved,all-rights-reserved,cc-by,cc-by-sa,cc-by-nd,cc-by-nc,cc-by-nc-nd
    -t --tags                comma separated list of tags
    -T --types               a comma separated list of types

options for sc
    -h --help                show help for this command

```

Another fun thing to do is to smashup songs from different genres.  By default, it will pick a sound from classical and a sound from storrytelling.


```
$ sc smashup happy
Playing http://soundcloud.com/treenaphoto/happy-mothers-day
Playing http://soundcloud.com/riccoescalante/those-happy-moments
```

name
    smashup - plays tracks from different genres simultaneously.  Like a mashup, but with more smash!

usage
    sc smashup [options] search terms

options
    -b --bpm[from]           return tracks with at least this bpm value
    -B --bpm[to]             return tracks with at least this bpm value
    -c --created_at[from]    (yyyy-mm-dd hh:mm:ss) return tracks created at this date or later
    -C --created_at[to]      (yyyy-mm-dd hh:mm:ss) return tracks created at this date or earlier
    -d --duration[from]      return tracks with at least this duration (in millis)
    -D --duration[to]        return tracks with at most this duration (in millis)
    -f --filter              One of: all,public,private,streamable,downloadable
    -g --genres              a comma separated list of genres
    -g --genres              comma-separated list of genres to smash!
    -i --ids                 a comma separated list of track ids to filter on
    -l --license             One of: no-rights-reserved,all-rights-reserved,cc-by,cc-by-sa,cc-by-nd,cc-by-nc,cc-by-nc-nd
    -t --tags                comma separated list of tags
    -T --types               a comma separated list of types

options for sc
    -h --help                show help for this command



Thanks
===

Some of the authentication documentation was derrived from the documentation of the `t` ruby gem.
