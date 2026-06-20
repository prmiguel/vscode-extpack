# vscode-extpack


```sh
docker build --no-cache --build-arg VSCODE_EXTENSIONS="kilocode.kilo-code" -t vscode-extpack .
```


```sh
docker run -d --name=vscode-extpack --cap-add=IPC_LOCK -e TZ=Etc/UTC -p 3000:3000 -p 3001:3001 --shm-size="1gb" --restart unless-stopped vscode-extpack:latest
```
