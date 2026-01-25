# `AI`rlock

## Design

- **Lightweight**: Uses the official `node:20-slim` Debian-based image.
- **No filesystem access**: The point is to prevent claude and other tools from
  being able to directly access your machine. As a result, we do not mount a
  volume.

## Quickstart

**Requirements**

- Docker CLI (or Podman)
- Runtime - I recommend Colima, or you can use the runtime that comes with
  Docker Desktop

### 1. Start runtime

- Docker Desktop: Open the application and leave it running
- Colima: Run `colima start`
  - Append `-m {number}` to set the VM memory limit in gigabytes (default is 2)
  - Append `-c {number}` to set the number of CPUs (default is 2)

On my Macbook Air M2 with 24g RAM and 8 cores, I run:

```
colima start -m 18 -c 6
```

The `compose.yaml` file allocates 16g RAM, with a soft limit of 12g and 4g of swap in the VM.

### 2. Build image

Run this command in the same directory as the `Dockerfile`.

#### a. WIth `docker compose`

I prefer this method, as it uses easily stored and versioned compose.yaml files
instead of long, fragile `docker` commands.

```sh
docker compose build
```

#### b. With `docker`

```sh
docker build -t airlock .
```

> [!WARNING]\
> If anything fails in the image build, the image won't be correctly tagged with
> the 'airlock' name, and the `run` command below won't be able to find the
> image based on that name.

Replace `airlock` with your desired image name, if different.

### 3. Create and run container

#### a. With Docker Compose

Start the container in detached mode with a specified profile.

```
docker compose --profile {profile} up -d
```

I have two profiles, `work` and `me`. For this example, let's start the `me` profile:

```
docker compose --profile me up -d
```

#### b. With `docker`

This command drops you into the container TTY.

```sh
docker run -it -m 8g -p 3000:3000 --name {container-name} airlock
```

| Flag / Argument    | Description                                                                                                              |
| :----------------- | :----------------------------------------------------------------------------------------------------------------------- |
| `-it`              | Interactive mode with TTY                                                                                                |
| `-m 8`             | Amount of RAM to allocate to container. In most cases, this should be the same amount given to the VM in the first step. |
| `-p 3000:3000`     | Expose any ports you want to use for development.                                                                        |
| `{container-name}` | Your desired container name. In `compose.yaml`, 

> [!IMPORTANT]\
> Replace `<container-name>` with the name of the project for which you intend
> to use this container.

### 4. Open terminals

#### a. With Docker Compose

With your chosen profile already running detached, run:

```
docker compose exec {profile} {shell}
```

In my case, I want to create a terminal in the `me` profile running `fish` shell:

```
docker compose exec me fish
```

Which has a kind of piratical ring to it.

#### b. With `docker`

The only advantage I can think of to *not* using Compose is that 
you have to _start_ and then _enter_ your container in separate commands.
The single `docker run ...` command run in step **3b** does both.

Open an external terminal window or split, then run:

```sh
docker exec -it <container-name> /bin/bash
```

You can safely `exit` each terminal independently of one another.

### 5. Exit container

Use `exit` or `ctrl + d` to exit the shell.

Use `docker stop `

Run `colima stop` (or close Docker Desktop) to stop the runtime.

### 6. Start container again

Once your container has been built, you can start and re-enter it at any time.
(At least, any time your VM is running ;))

```
docker start -ai <container-name>
```

## Usage

My workflow for this setup is to mostly treat the container as an emphemeral
convenience. As I discover new use cases and needs, I modify the container,

However, the beauty of working out of a Docker container is that it's portable!
You could deploy this anywhere you want, SSH into it, and pick up exactly where
you left off.

### Git

Create an SSH key:

```
ssh-keygen -t ed25519 -C "text comment"
```

Save it with a passkey of your choice, then run this and copy the entire
results. This is your public key.

```
cat /root/.ssh/id_ed25519.pub
```

### Claude Code

The Dockerfile installed Claude Code for you.

Run `claude` to setup and authenticate Claude as normal.

Once Claude has been authenticated, you can copy its config out of the container
with the following command. This way, you can copy in your auth after future
image rebuilds.

```sh
# Copy entire .claude folder
docker cp {container-name}:/root/.claude ./claude-config/

# Copy auth only
docker cp {container-name}:/root/.claude/.credentials.json ./claude-config/
```

## Changes and updates

You can add lots of functionality to the container without a rebuild. After all,
we do have 2 full package managers and all of Debian at our disposal!

However, it's probably inevitable that you'll need to start fresh at some point.
Here are some examples of changes that would require an image rebuild:

### Image changes

    - Switching the base image
    - Changing the working directory

### Runtime parameters

Runtime parameters don't require a rebuilt image, but do require a new
container:

    - Adding more RAM
    - Exposing different ports
    - Changing port mappings
    - Renaming the container
    - Adding volume mounts
    - Changing CPU limits (not)

---

## Notes

There are lots of "fun" things you run into when using this setup. If you're
like me, these are things you've done once or twice when setting up a machine
and have since forgotten about. After all, you are switching your workflow over
to a fresh Linux install!

Here is an incomplete list:

- Set git author identity (email and name)
- Authentication with git
