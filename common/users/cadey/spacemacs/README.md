# spacemacs2nix

You can regenerate the attribute set of layers to packages via:

```
./spacemacs2nix.el > all-spacemacs-packages.nix
```

And you can generate the transitive list of layers and themes your `~/.spacemacs` uses via:

```
./dotspacemacs-used-layers.el > $USER-layers.nix
./dotspacemacs-used-themes.el > $USER-themes.nix
```

Then you can build an Emacs with all of your packages:

```nix
with import <nixpkgs> { };

(callPackage ./spacemacs-with-packages.nix { }) {
  layers = import ./my-layers.nix;
  themes = import ./my-themes.nix;
}
```

You need to change `~/.spacemacs` to make it not attempt deleting system packages:

```elisp
dotspacemacs-install-packages 'used-but-keep-unused
```
