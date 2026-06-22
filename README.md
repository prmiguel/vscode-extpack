# vscode-extpack

Docker image bundling a pre-configured openvscode-server with VS Code extensions and settings baked in. Spun up via `compose.yml` to provide a ready-to-use IDE with all workspace repos mounted.

## Role in the Workspace

`vscode-extpack` is the **IDE delivery** component of the 5-repo workspace ecosystem. It packages `settings.json` (shared preferences), extensions defined during build, and the openvscode-server runtime — all mountable to `/workspace/`.

See [`ai/rules/workspace-structure.md`](https://github.com/prmiguel/ai/blob/main/rules/workspace-structure.md) for the full architecture.

## Build

```sh
docker build --no-cache --build-arg VSCODE_EXTENSIONS="kilocode.kilo-code" -t vscode-extpack .
```

## Run

```sh
docker compose up -d
```

Or manually:

```sh
docker run -d --name=vscode-extpack --cap-add=IPC_LOCK \
  -e TZ=Etc/UTC -p 3000:3000 -p 3001:3001 \
  --shm-size="1gb" --restart unless-stopped \
  -v /workspace:/workspace \
  vscode-extpack:latest
```

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Builds openvscode-server with extensions baked in |
| `compose.yml` | Container orchestration with volume mounts |
| `settings.json` | Shared VS Code preferences for all profiles |
| `install-extensions.sh` | Extension installation script used during build |
| `autostart_wayland` | Wayland autostart helper for the container |
