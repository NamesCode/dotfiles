# Name's Nix config

A real mess but y'know.

## Installation

### Asahi Linux

Heyo all you lovely Asahi users!

To use and install my config you must follow [tpwrules installation guide](https://github.com/tpwrules/nixos-apple-silicon/blob/main/docs/uefi-standalone.md)
but you must **NOT** use the ISO provided by them.

Instead, you will need to use the ISO that I provide.

Why is that you may be asking? tpwrules ISO *doesn't* support OpenZFS as it is an out of tree Linux module,
and this is completely understandable.
This is however an issue for this particular config as we want to use ZFS as our primary filesystem.

If you do not trust my prebuilt ISO, feel free to compile it yourself by running:
`nix build .#asahi-zfs-iso`

## Usage

### Creating a user config

To create a user config you need to create a user folder containing a `home.nix` in the users folder.
This `home.nix` should handle all your user specific configuration, any modules you can share across users should be placed into `modules/home-manager/` otherwise place them wherever you feel.

### Creating a system

#### Naming scheme

At the moment, the names of systems are tied to their function and stuff from shows I like.

So far we have:

- navi [ My main system ]
- coplandos [ macOS / nix-darwin systems ]
- lain [ home-manager systems ]
- magi [ Servers (up to 3 only) ]
    - casper [ Intermediate ]
    - balthasar [ Most powerful server ]
    - melchior [ Least powerful server ]
