# Docker Dependencies

this repo faciliitates syncing multiarch docker images from their vendor provided repositories and our private AWS ECR docker repositories

## dependencies

execute `make deps` to download the regctl binary

## usage

see Makefile for each directory and modify the image version value as needed.
you should use Leapp to establish a administrator session to the PaloloArtifacts account.

sync a single image

```sh
make -C [directory] sync
```

sync all images

```sh
make syncall
```
