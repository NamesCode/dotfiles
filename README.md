# Name's Nix config

A real mess but y'know.

## Installation

No clue, gotta fill in l8r.

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
- the-wired [ Server ]
