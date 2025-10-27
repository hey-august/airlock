# aiRLOCK

## Design

- **Lightweight**: Uses the official `node:20-slim` Debian-based image.
- **No filesystem access**: The point is to prevent claude and other tools from being able to directly access your machine.
  As a result, we do not mount a volume.

## Quickstart

**Requirements**

- Docker CLI (or Podman)
- Runtime - I recommend Colima, or you can use the runtime that comes with Docker Desktop

### 1. Start runtime

  - Docker Desktop: Open the application and leave it running
  - Colima: Run `colima start`
  
### 2. Build image

Run this command in the same directory as the `Dockerfile`.

`docker build -t airlock .`

Replace `airlock` with your desired image name, if different.

### 3. Create and run container

`docker run -it -p 3000:3000 --name <container-name> airlock`

> [!IMPORTANT]  
> Replace `<container-name>` with the name of the project for which you intend to use this container.

| Flag | Description |
| :--- | :---------- |
| `-it` | Interactive mode with TTY |
| `-p 3000:3000` | Expose any ports you want to use for development. |

### 4. Exit container

Use `exit` or `ctrl + d` to exit the shell and stop the container.

Run `colima stop` (or close Docker Desktop) to stop the runtime.

### 5. Additional terminals

Open an external terminal window or split, then run:

`docker exec -it <container-name> /bin/bash`

You can safely `exit` each terminal independently of one another.

### 6. Start container again

Once your container has been built, you can start and re-enter it at any time.

`docker start -ai <container-name>`

## Notes

There are lots of "fun" things you run into when using this setup.
After all, you are switching your workflow over to a fresh Linux install!

Here is an incomplete list:

- Set git author identity (email and name)
- Authentication with git in general
