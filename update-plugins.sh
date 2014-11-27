#!/bin/bash

cd ${HOME}/.vim/bundle

for dir in `ls`; do
    cd ${HOME}/.vim/bundle/$dir
    git pull origin master
done

