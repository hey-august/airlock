#!/bin/bash

echo "
===============
cloning Tmux Package Manager
==============="

if [ -d ~/.tmux/plugins/tpm ]; then
	echo "~/.tmux/plugins/tpm already exists."
	exit 1
else
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

###############

echo "
===========================
adding lvim shell aliases
==========================="

read -p "Add lvim Bash alias? (y/n): " choice
if [ "$choice" = "y" ]; then
	echo "alias 'NVIM_APPNAME'=lvim nvim" >> ~/.bash_aliases
	echo "run source ~/.bashrc"
fi

read -p "Add lvim Fish alias? (y/n): " choice
if [ "$choice" = "y" ]; then
	fish -c 'alias -s "NVIM_APPNAME=lvim nvim"'
fi

