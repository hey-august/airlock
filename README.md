# aiRLOCK

## Design

- **Lightweight**: Uses the official `node:20-slim` Debian-based image.
- **No filesystem access**: The point is to prevent claude and other tools from being able to directly access your machine.
  As a result, we do not mount a volume.

## Quickstart

### Requirements

- Docker (or Podman)
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
| `-p 3000:3000` | Expose any ports you want to use. |
| `--rm` | **Optional, for emphemeral containers**: Automatically removes the container when it stops. Not recommended for this use case as you'd need to reauthenticate Claude Code every time you ran the container. |

### 4. Exit container

Use `exit` or `ctrl + d` to exit the shell and stop the container.

Run `colima stop` (or close Docker Desktop) to stop the runtime.

### 5. Additional terminals

Open an external terminal window or split, then run:

`docker exec -it <container-name> /bin/sh`

### 6. Start container again

Once your container has been built, you can start and re-enter it at any time.

`docker start -ai <container-name>`
