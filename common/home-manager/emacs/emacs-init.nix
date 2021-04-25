# Copyright (c) 2019 Robert Helgesson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Vendored from: https://gitlab.com/rycee/nur-expressions/blob/master/hm-modules/emacs-init.nix

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.emacs.init;

  packageFunctionType = mkOptionType {
    name = "packageFunction";
    description = "function from epkgs to package";
    check = isFunction;
    merge = mergeOneOption;
  };

  usePackageType = types.submodule ({ name, config, ... }: {
    options = {
      enable = mkEnableOption "Emacs package ${name}";

      package = mkOption {
        type = types.either (types.str // { description = "name of package"; })
          packageFunctionType;
        default = name;
        description = ''
          The package to use for this module. Either the package name
          within the Emacs package set or a function taking the Emacs
          package set and returning a package.
        '';
      };

      defer = mkOption {
        type = types.either types.bool types.ints.positive;
        default = false;
        description = ''
          The <option>:defer</option> setting.
        '';
      };

      demand = mkOption {
        type = types.bool;
        default = false;
        description = ''
          The <option>:demand</option> setting.
        '';
      };

      diminish = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:diminish</option>.
        '';
      };

      chords = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "jj" = "ace-jump-char-mode";
          "jk" = "ace-jump-word-mode";
        };
        description = ''
          The entries to use for <option>:chords</option>.
        '';
      };

      mode = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:mode</option>.
        '';
      };

      after = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:after</option>.
        '';
      };

      bind = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "M-<up>" = "drag-stuff-up";
          "M-<down>" = "drag-stuff-down";
        };
        description = ''
          The entries to use for <option>:bind</option>.
        '';
      };

      bindLocal = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = { };
        example = {
          helm-command-map = { "C-c h" = "helm-execute-persistent-action"; };
        };
        description = ''
          The entries to use for local keymaps in <option>:bind</option>.
        '';
      };

      bindStar = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "M-<up>" = "drag-stuff-up";
          "M-<down>" = "drag-stuff-down";
        };
        description = ''
          The entries to use for <option>:bind*</option>.
        '';
      };

      bindKeyMap = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = { "C-c p" = "projectile-command-map"; };
        description = ''
          The entries to use for <option>:bind-keymap</option>.
        '';
      };

      command = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:commands</option>.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Code to place in the <option>:config</option> section.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional lines to place in the use-package configuration.
        '';
      };

      general = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Code to place in the <option>:general</option> section.
        '';
      };

      hook = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          The entries to use for <option>:hook</option>.
        '';
      };

      init = mkOption {
        type = types.lines;
        default = "";
        description = ''
          The entries to use for <option>:init</option>.
        '';
      };

      assembly = mkOption {
        type = types.lines;
        readOnly = true;
        internal = true;
        description = "The final use-package code.";
      };
    };

    config = mkIf config.enable {
      assembly = let
        quoted = v: ''"${escape [ ''"'' ] v}"'';
        mkBindHelper = cmd: prefix: bs:
          optionals (bs != { }) ([ ":${cmd} (${prefix}" ]
            ++ mapAttrsToList (n: v: "  (${quoted n} . ${v})") bs ++ [ ")" ]);

        mkAfter = vs: optional (vs != [ ]) ":after (${toString vs})";
        mkCommand = vs: optional (vs != [ ]) ":commands (${toString vs})";
        mkDiminish = vs: optional (vs != [ ]) ":diminish (${toString vs})";
        mkMode = map (v: ":mode ${v}");
        mkBind = mkBindHelper "bind" "";
        mkBindStar = mkBindHelper "bind*" "";
        mkBindLocal = bs:
          let mkMap = n: v: mkBindHelper "bind" ":map ${n}" v;
          in flatten (mapAttrsToList mkMap bs);
        mkBindKeyMap = mkBindHelper "bind-keymap" "";
        mkChords = mkBindHelper "chords" "";
        mkHook = map (v: ":hook ${v}");
        mkDefer = v:
          if isBool v then
            optional v ":defer t"
          else
            [ ":defer ${toString v}" ];
        mkDemand = v: optional v ":demand t";
        extraAfter = optional (config.general != "") "general";
      in concatStringsSep "\n  " ([ "(use-package ${name}" ]
        ++ mkAfter (config.after ++ extraAfter) ++ mkBind config.bind
        ++ mkBindStar config.bindStar ++ mkBindKeyMap config.bindKeyMap
        ++ mkBindLocal config.bindLocal ++ mkChords config.chords
        ++ mkCommand config.command ++ mkDefer config.defer
        ++ mkDemand config.demand ++ mkDiminish config.diminish
        ++ mkHook config.hook ++ mkMode config.mode
        ++ optionals (config.init != "") [ ":init" config.init ]
        ++ optionals (config.config != "") [ ":config" config.config ]
        ++ optionals (config.general != "") [ ":general" config.general ]
        ++ optional (config.extraConfig != "") config.extraConfig) + ")";
    };
  });

  usePackageStr = name: pkgConfStr: ''
    (use-package ${name}
      ${pkgConfStr})
  '';

  mkRecommendedOption = type: extraDescription:
    mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable recommended ${type} settings.
      '' + optionalString (extraDescription != "") ''
        </para><para>
        ${extraDescription}
      '';
    };

  # Recommended GC settings.
  gcSettings = ''
    (defun hm/reduce-gc ()
      "Reduce the frequency of garbage collection."
      (setq gc-cons-threshold 402653184
            gc-cons-percentage 0.6))

    (defun hm/restore-gc ()
      "Restore the frequency of garbage collection."
      (setq gc-cons-threshold 16777216
            gc-cons-percentage 0.1))

    ;; Make GC more rare during init and while minibuffer is active.
    (eval-and-compile #'hm/reduce-gc)
    (add-hook 'minibuffer-setup-hook #'hm/reduce-gc)

    ;; But make it more regular after startup and after closing minibuffer.
    (add-hook 'emacs-startup-hook #'hm/restore-gc)
    (add-hook 'minibuffer-exit-hook #'hm/restore-gc)

    ;; Avoid unnecessary regexp matching while loading .el files.
    (defvar hm/file-name-handler-alist file-name-handler-alist)
    (setq file-name-handler-alist nil)

    (defun hm/restore-file-name-handler-alist ()
      "Restores the file-name-handler-alist variable."
      (setq file-name-handler-alist hm/file-name-handler-alist)
      (makunbound 'hm/file-name-handler-alist))

    (add-hook 'emacs-startup-hook #'hm/restore-file-name-handler-alist)
  '';

  # Whether the configuration makes use of `:diminish`.
  hasDiminish = any (p: p.diminish != [ ]) (attrValues cfg.usePackage);

  # Whether the configuration makes use of `:bind`.
  hasBind =
    any (p: p.bind != { } || p.bindStar != { }) (attrValues cfg.usePackage);

  # Whether the configuration makes use of `:chords`.
  hasChords = any (p: p.chords != { }) (attrValues cfg.usePackage);

  # Whether the configuration makes use of `:diminish`.
  hasGeneral = any (p: p.general != "") (attrValues cfg.usePackage);

  usePackageSetup = ''
    (eval-when-compile
      (require 'package)

      (setq package-archives nil
            package-enable-at-startup nil
            package--init-file-ensured t)

      (require 'use-package)

      ;; To help fixing issues during startup.
      (setq use-package-verbose ${
        if cfg.usePackageVerbose then "t" else "nil"
      }))
  '' + optionalString hasDiminish ''
    ;; For :diminish in (use-package).
    (require 'diminish)
  '' + optionalString hasBind ''
    ;; For :bind in (use-package).
    (require 'bind-key)
  '' + optionalString hasChords ''
    ;; For :chords in (use-package).
    (use-package use-package-chords
      :config (key-chord-mode 1))
  '' + optionalString hasGeneral ''
    ;; For :general in (use-package).
    (use-package general
      :config
      (general-evil-setup))
  '';

  initFile = ''
    ;;; hm-init.el --- Emacs configuration à la Home Manager.
    ;;
    ;; -*- lexical-binding: t; -*-
    ;;
    ;;; Commentary:
    ;;
    ;; A configuration generated from a Nix based configuration by
    ;; Home Manager.
    ;;
    ;;; Code:

    ${optionalString cfg.startupTimer ''
      ;; Remember when configuration started. See bottom for rest of this.
      ;; Idea taken from http://writequit.org/org/settings.html.
      (defconst emacs-start-time (current-time))
    ''}

    ${optionalString cfg.recommendedGcSettings gcSettings}

    ${cfg.prelude}

    ${usePackageSetup}
  '' + concatStringsSep "\n\n" (map (getAttr "assembly")
    (filter (getAttr "enable") (attrValues cfg.usePackage))) + ''

      ${cfg.postlude}

      ${optionalString cfg.startupTimer ''
        ;; Make a note of how long the configuration part of the start took.
        (let ((elapsed (float-time (time-subtract (current-time)
                                                  emacs-start-time))))
          (message "Loading settings...done (%.3fs)" elapsed))
      ''}

      (provide 'hm-init)
      ;; hm-init.el ends here
    '';

in {
  options.programs.emacs.init = {
    enable = mkEnableOption "Emacs configuration";

    recommendedGcSettings = mkRecommendedOption "garbage collection" ''
      This will reduce garbage collection frequency during startup and
      while the minibuffer is active.
    '';

    startupTimer = mkEnableOption "Emacs startup duration timer";

    prelude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the beginning of
        <filename>init.el</filename>.
      '';
    };

    postlude = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Configuration lines to add in the end of
        <filename>init.el</filename>.
      '';
    };

    usePackageVerbose = mkEnableOption "verbose use-package mode";

    usePackage = mkOption {
      type = types.attrsOf usePackageType;
      default = { };
      example = literalExample ''
        {
          dhall-mode = {
            mode = [ '''"\\.dhall\\'"''' ];
          };
        }
      '';
      description = ''
        Attribute set of use-package configurations.
      '';
    };
  };

  config = mkIf (config.programs.emacs.enable && cfg.enable) {
    programs.emacs.extraPackages = epkgs:
      let
        getPkg = v:
          if isFunction v then
            [ (v epkgs) ]
          else
            optional (isString v && hasAttr v epkgs) epkgs.${v};

        packages = concatMap (v: getPkg (v.package))
          (builtins.attrValues cfg.usePackage);
      in [
        ((epkgs.trivialBuild {
          pname = "hm-init";
          version = "0";
          src = pkgs.writeText "hm-init.el" initFile;
          packageRequires = lists.unique ([ epkgs.use-package ] ++ packages
            ++ optional hasBind epkgs.bind-key
            ++ optional hasDiminish epkgs.diminish
            ++ optional hasChords epkgs.use-package-chords
            ++ optional hasGeneral epkgs.general);
          preferLocalBuild = true;
          allowSubstitutes = false;
        }).overrideAttrs (attr: {
          buildPhase = ''
            runHook preBuild
            runHook postBuild
          '';
        }))
      ];

    home.file.".emacs.d/init.el".text = ''
      (require 'hm-init)
      (provide 'init)
    '';
  };
}
