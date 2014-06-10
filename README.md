Stante Pede
===========

Emacs configuration of [Sebastian Wiesner](http://www.lunaryorn.com/about)

Requirements
------------

- Emacs 24.4
- [Cask][]

Setup
-----

Clone the repo, and install all Emacs packages:

```console
$ git clone --recursive https://github.com/lunaryorn/stante-pede.git ~/.emacs.d
$ cd ~/.emacs.d
$ cask install
```

### OS X support ###

```console
$ brew install trash coreutils
```

### Spell checking ###

```console
$ brew install hunspell
```

On OS X, download dictionaries from [OpenOffice][], and put them into
`~/Library/Spelling`.  On Linux, install the Hunspell dictionaries from the
package repositories, e.g. `apt-get install hunspell-en-us`.

### Python support ###

```console
$ pip install -U --user virtualenv pylint ipython
```

### Haskell support ###

```console
$ cabal install hlint hasktags hoogle present
```

### Shell scripting ###

```console
$ cabal install shellcheck
```

### Markdown support ###

```console
$ cabal install pandoc
```

### Ansible support ###

```console
$ brew install ansible
```

[Cask]: http://cask.readthedocs.org/en/latest/
[OpenOffice]: https://wiki.openoffice.org/wiki/Dictionaries

Usage
-----

The entire configuration is in `init.el`.  The key bindings are at the end of
the file.

For details, read the source, and the documentation of the corresponding
packages.  See `Cask` for a list of all installed packages.

Notable packages
----------------

- Version control: [Magit](https://github.com/magit/magit) and
  [Diff Hl](https://github.com/dgutov/diff-hl)
- Color theme: [Solarized Light](https://github.com/bbatsov/solarized-emacs),
  with the [Source Code Pro](https://github.com/adobe/source-code-pro) font
- Mode line: [Smart Mode Line](https://github.com/Bruce-Connor/smart-mode-line),
  [Anzu](https://github.com/syohex/emacs-anzu)
- Minibuffer input and completion: [SMex](https://github.com/nonsequitur/smex),
  [Ido Ubiquituous](https://github.com/DarwinAwardWinner/ido-ubiquitous),
  [Flx](https://github.com/lewang/flx) and
  [Ido Vertical Mode](https://github.com/gempesaw/ido-vertical-mode.el)
- Visual guides:
  [Fill Column Indicator](https://github.com/alpaker/Fill-Column-Indicator) and
  [Page Break Lines](https://github.com/purcell/page-break-lines)
- Undo and killing: [Undo Tree](http://www.dr-qubit.org/emacs.php#undo-tree),
  [Browse Kill Ring](https://github.com/browse-kill-ring/browse-kill-ring) and
  [Easy Kill](https://github.com/leoliu/easy-kill)
- Region and editing:
  [Expand Region](https://github.com/magnars/expand-region.el),
  [Multiple Cursors](https://github.com/magnars/multiple-cursors.el) and
  [Visual Regexp](https://github.com/benma/visual-regexp.el)
- In-buffer navigation:
  [ACE Jump Mode](https://github.com/winterTTr/ace-jump-mode) and
  [Imenu Anywhere](https://github.com/vitoshka/imenu-anywhere)
- Syntax checking: [Flycheck](http://flycheck.readthedocs.org)
- Auto-completion: [Company Mode](http://company-mode.github.io)
- Symbol highlighting and operations:
  [Highlight Symbol](https://github.com/nschum/highlight-symbol.el)
- Project navigation: [Projectile](https://github.com/bbatsov/projectile)
- Search: [Ag](https://github.com/Wilfred/ag.el)
- Lisp editing: [Paredit](http://www.emacswiki.org/emacs/ParEdit) and
  [Rainbow Delimiters](https://github.com/jlr/rainbow-delimiters)
- Emacs Lisp tools: [Macrostep](https://github.com/joddie/macrostep),
  [Elisp Slime Nav](https://github.com/purcell/elisp-slime-nav) and
  [Flycheck Cask](https://github.com/flycheck/flycheck-cask)
- Python tools: [Anaconda Mode](https://github.com/proofit404/anaconda-mode)
- Haskell tools:
  [Flycheck Haskell](https://github.com/flycheck/flycheck-haskell)