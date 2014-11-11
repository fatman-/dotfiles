#!/bin/bash

# Variables
dir=~/.dotfiles
olddir=~/.dotfiles/oldFiles
files="bash_profile"

# Create oldFiles folder if not present
echo "Creating $olddir (if necessary) for backup of existing dotfiles"
mkdir -p $olddir
echo "...done"

# Change to the dotfiles directory
echo "Moving to the $dir directory"
cd $dir
echo "...done"

# Move existing dotfiles from home to oldFiles
for file in $files; do
    echo "Moving old dotfiles to $olddir"
    mv ~/.$file $olddir/
done

# Create symlinks
for file in $files; do
    echo "Creating symlink to $file in home directory"
    ln -s $dir/$file ~/.$file
done

echo "Dotfiles initialized"
