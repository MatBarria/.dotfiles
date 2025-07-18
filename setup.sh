#!/usr/bin/env bash

set -e
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "$script_dir"

dry_run="0"
if [[ "$1" == "--dry" ]]; then
    dry_run="1"
fi

log() {
    if [[ $dry_run == "1" ]]; then
        echo "[DRY_RUN]: $1"
    else
        echo "$1"
    fi
}

update_files() {
    pushd "$1" > /dev/null
    (
        configs=$(find . -mindepth 1 -maxdepth 1 -type d)

        for c in $configs; do
            directory="${2%/}/${c}"
            if [[ $dry_run == "1" ]]; then
                log "Removing: $directory"
            else
                log "Removing: $directory"
                rm -rf "$directory"
            fi
        done

        if [[ $dry_run == "1" ]]; then
            log "Copying contents of $(realpath .) to $2"
            find . -type f | while read -r f; do
                log "Would copy: $f → $2"
            done
        else
            log "Copying contents of $(realpath .) to $2"
            find . -type f | while read -r f; do
                rel_path="${f#./}"
                log "Copying: $f → $2/$rel_path"
            done
            cp -vr . "$2"
        fi
    )
    popd > /dev/null
}

run_env() {
    pushd "$script_dir" > /dev/null

    log "Updating ~/.config"
    update_files .config "$HOME/.config"

    log "Updating ~/.local"
    update_files .local "$HOME/.local"

    log "Copying home files"
    if [[ $dry_run == "0" ]]; then
        for file in .bash_setup .gitconfig .tmux.conf; do
            src="$script_dir/env/$file"
            dest="$HOME/$file"
            log "Copying: $src → $dest"
            cp -v "$src" "$dest"
        done
    else
        for file in .bash_profile .gitconfig .tmux.conf; do
            src="$script_dir/env/$file"
            dest="$HOME/$file"
            log "Would copy: $src → $dest"
        done
    fi

    popd > /dev/null
}

run_env
