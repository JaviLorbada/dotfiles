.dotfiles [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/JaviLorbada/JLTMDbClient/blob/master/LICENSE)
========

My terminal dotfiles / setup

========
git-flow completion requires git-completion to work. How exactly you go about installing git-completion varies wildly from system to system, so it's hard to give exact installation instructions. 


## OS X:

By far the easiest way to install both Git and git-completion is via [Homebrew](http://brew.sh/). For further details about the installation process follow [this guide.](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

### Homebrew and Git

1. [Install homebrew](http://brew.sh/)

	```
	$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```
2. Install Git:

	```
	$ brew doctor
	$ brew update
	$ brew install git
	```
 
3. Install bash-completion: 

	```
	$ brew install git bash-completion
	``` 
		
(Note: If this install fails with a 404 error, and you already have git installed, just remove the git part of this brew install)
	
4. Add bash-completion to your [`.bash_profile`](https://github.com/JaviLorbada/dotfiles/blob/master/.bash_profile):

        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

## Git Flow:

A collection of Git extensions to provide high-level repository operations for Vincent Driessen's [branching model](http://nvie.com/posts/a-successful-git-branching-model/).

[Installation](https://github.com/nvie/gitflow/wiki/Mac-OS-X):

	$ brew install git-flow

## RVM:

[RVM](https://rvm.io/) stands for Ruby Version Manager, and is one of the most popular tools that allow you to install and manage multiple versions of Ruby and Rails on the same computer. And I use it.

[Installation](https://github.com/wayneeseguin/rvm#installation):

	$ curl -L https://get.rvm.io | bash -s stable --autolibs=enabled [--ruby] [--rails] [--trace]

	
(Note: Read the [RVM installation documentation](https://github.com/wayneeseguin/rvm#installation) to see all the different options you can use.)

## Cocoapods:

[CocoaPods](http://cocoapods.org/) manages library dependencies for your Xcode projects.

[Installation](http://guides.cocoapods.org/using/getting-started.html#installation):

	$ sudo gem install cocoapods

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

Additionally, you may want to install some of the [software](https://github.com/JaviLorbada/dotfiles/blob/master/software.md) I daily use. 


## Contact:

- [Javi Lorbada](mailto:javugi@gmail.com) 
- Follow [@javi_lorbada](https://twitter.com/javi_lorbada) on twitter
- http://javilorbada.me/
