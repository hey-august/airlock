# aiRLOCK

## Design

- **Lightweight**
- **No filesystem access**: The point is to prevent claude and other tools from being able to directly access your machine.
  As a result, we do not mount a volume.

## Requirements

- Docker (or Podman)
- Runtime: I recommend Colima, or you can use the runtime that comes with Docker Desktop

## Quickstart

1. Start runtime

  - Docker Desktop: Just open the application
  - Colima: Run `colima start`
  
2. Build image

Replace `image-name` with your desired image name.

```
docker build -t image-name .
```

3. Run container

```
docker run -it -p 3000:3000  test
```

| Flag | Description |
| :--- | :---------- |
| `-it` | Interactive mode with TTY |
| `-p 3000:3000` | Expose any ports you want to use. |
| `--rm` | Automatically removes the container when it stops. |

4. Exit container

With `ctrl + d`

5. Additional terminals

Open external terminal windows or splits, then run `docker exec -it <container-name> /bin/sh`

6. Start container again

```
docker start -ai sw-docs
```
