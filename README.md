# OCaml Wake-On-LAN

OCaml implementation of Wake-On-LAN (WOL). Comes with a CLI to send WOL packets and check if we can connect on the standard SSH port (22).

We also provide a library if you want to embed functionality in your own application.

## TODO

- [ ] Consider splitting out Eio parts to separate library
- [ ] Move unix stuff to separate library
- [ ] Expose more options in CLI

## CLI

```
NAME
       wol

SYNOPSIS
       wol [--check=IP] [OPTION]… MAC

ARGUMENTS
       MAC (required)
           Mac address of target computer.

OPTIONS
       -c IP, --check=IP
           Check the IP if target is up.

COMMON OPTIONS
       --help[=FMT] (default=auto)
           Show this help in format FMT. The value FMT must be one of auto,
           pager, groff or plain. With auto, the format is pager or plain
           whenever the TERM env var is dumb or undefined.

EXIT STATUS
       wol exits with:

       0   on success.

       123 on indiscriminate errors reported on standard error.

       124 on command line parsing errors.

       125 on unexpected internal errors (bugs).
```
