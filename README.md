# aiRLOCK

## About

## Design

- **Lightweight**: 
- **Ephemeral**: Changes are discarded automatically when the container stops. 
  Work must be intentionally saved (committed out via git or otherwise copied to the permanent disk)
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

```
docker build -t test .
```

3. Run container

```
docker run -it -p 3000:3000 --rm test
```

Flag explainer:

| `-it` | Interactive mode with TTY |
| `-p 3000:3000` | Expose any ports you want to use. |
| `--rm` | Automatically removes the container when it stops. |
