# kiss-find

A tool for indexing and searching kiss packages from repositories across the internet.

Example usage:

    $ kiss find amf
    amfora     1.7.2 2  https://github.com/jedahan/kiss-repo      amfora            a fancy terminal browser for the gemini protocol
    amfora     1.8.0 1  https://github.com/aabacchus/kiss-repo    amfora            a fancy terminal browser for the gemini protocol
    bamf       0.5.4 1  https://github.com/eudaldgr/elementaKISS  extra/bamf
    tinyramfs  git 1    https://github.com/mmatongo/dm            kernel/tinyramfs

Updating the database using the script:

    $ kiss find -u

## Building

You don't have to build the database yourself; it is generate and uploaded to https://aabacchus.github.io/kiss-find/db.csv by a GitHub Action. You still can if you want to, though.

To build the database, run

    make

This uses git to clone the repositories, and optionally discovers github repos using the `gh` tool with `jq`.

To install the script and database, run

    make install

optionally, choosing a particular `PREFIX`, `CONFIGDIR`, or `DESTDIR`.

## Adding a repository

If your repository is on github, just add the `kiss-repo` topic and it should be automatically picked up.

If your repository is anywhere else, open a pull request or issue for it to be added to the `include` file.

## Removing a repository

If you would not like your repository indexed, it should be added to the `filter` file.

## Credits

Created by [@admicos](https://ecmelberk.com), rewritten by [@jedahan](https://github.com/jedahan), simplified by aabacchus.
