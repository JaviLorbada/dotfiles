.dotfiles [![License MIT](http://b.repl.ca/v1/License-MIT-blue.png)](https://github.com/JaviLorbada/JLTMDbClient/blob/master/LICENSE)
========

My terminal dotfiles / setup

========
git-flow completion requires git-completion to work. How exactly you go about installing git-completion varies wildly from system to system, so it's hard to give exact installation instructions. 


## OS X:

By far the easiest way to install both Git and git-completion is via [Homebrew](http://mxcl.github.com/homebrew/), so you should pick that one.

### Homebrew

1. [Install homebrew](http://github.com/mxcl/homebrew/wiki/installation)
2. Install Git and bash-completion: `brew install git bash-completion` (Note: If this install fails with a 404 error, and you already have git installed, just remove the git part of this brew install)
3. Add bash-completion to your [`.bash_profile`](https://github.com/JaviLorbada/dotfiles/blob/master/.bash_profile):

        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

## Install guide:

1. Clone `git clone https://github.com/JaviLorbada/dotfiles`
2. Run `cd dotfiles`
3. Run `install.sh`

You may want to add your name `~/.dotfiles/.gitconfig`

```
[user]
    name = JaviLorbada
    email = javugi@gmail.com
[github]
    user = JaviLorbada
    username = JaviLorbada
```

## Contact:

- [Javi Lorbada](mailto:javugi@gmail.com) 
- Follow [@javi_lorbada](https://twitter.com/javi_lorbada) on twitter
- http://javilorbada.me/
