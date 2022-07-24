## Instructions


### Rename the folder "local" to ".local" and move it to your $HOME.
The path would look something like `/home/<user>/.local`.
The command to do so right from the current directory would be:

`mv ./local ./.local && cp -r ./.local ~/`

### Give execute permissions
`chmod +x ./usr/local/bin/archiveFiles.sh`

### As root, copy the "usr" folder to root ("/")
`sudo cp -r ./usr /`

