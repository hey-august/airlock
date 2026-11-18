# Migrating a container

Each service keeps its state in two named volumes: `<service>-home` at `/airlock` and `<service>-brew` at `/home/linuxbrew`. They survive rebuilds and `--force-recreate`. `docker-compose down -v` deletes them.

The same steps move state to a new container on this machine or another one. When moving between CPU architectures, skip `brew.tar` and reinstall Homebrew packages, `node_modules` and virtualenvs.

## Export

```sh
docker exec work.airlock fish -c 'rm -rf ~/.cache ~/.npm'   # optional, shrinks the copy
docker stop work.airlock
docker cp work.airlock:/airlock - > home.tar
docker cp work.airlock:/home/linuxbrew - > brew.tar
```

For another Mac, `scp home.tar brew.tar other-mac:`.

## Import

With this repo checked out and Colima running:

```sh
docker-compose up -d work
docker cp -a - work.airlock:/ < home.tar
docker cp -a - work.airlock:/home < brew.tar
docker-compose restart work
docker exec work.airlock ls -ln /airlock | head   # expect uid 1000, not 0
```

`-a` keeps `dev` ownership. Import into fresh volumes: files already in a volume that aren't in the tar are left in place.

## One-time: writable layer to volumes

Containers created before `compose.yaml` had volumes keep their state in the writable layer. Export as above and check the tar sizes, since recreating deletes the old container. Then:

```sh
docker-compose up -d --force-recreate work
```

and continue with the import steps after `up`.

If `docker ps -a` shows `airlock-airlock-1`, it's a leftover from the old profiles setup. Check it with `docker diff airlock-airlock-1`, then `docker rm -f airlock-airlock-1`.
