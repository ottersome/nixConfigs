# Introduction
This OS is mean to be reproducible and shared amongst different users with as little conflict as possible.
For this to be the case every user will chose and pick what packages will be used in their environment and these packages will
be installed in isolation from other users

# Instructions
## Installating Dependencies
- In order to install packages independently to other users this configuration uses [home-manager](https://nixos.wiki/wiki/Home_Manager)
- 🗒If you only one to take one thing away from this configuration is this:

  > Configuration *declarative*, not *imperative*. 
  > Meaning that when you want a new piece of software installed you must *declare* it in a config file and not *imperatively* run a command.
  > This system will look at this config file and install stuff under the hood for you.
  > I repeat: You should **NOT** look for commands like: `sudo apt install ...` or `yum install ..` or `sudo yay -Syu ...`. 
  > If you force this imperative approach you will have a *very bad time*.
  > See the next bullet point for detailed instructions.

- You may find the file in which all your installations are declared in `/home/youruser/.config/nixpkgs/home.nix`
- Your file will look something like:

