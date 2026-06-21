FROM lscr.io/linuxserver/vscode:latest

# Comma-separated list of VS Code extension IDs, e.g.:
#   --build-arg VSCODE_EXTENSIONS="ms-python.python,redhat.java,vscjava.vscode-spring-boot-dashboard"
ARG VSCODE_EXTENSIONS=""

USER root
RUN chown -R abc:abc /config
COPY --chown=abc:abc install-extensions.sh /tmp/install-extensions.sh
RUN chmod +x /tmp/install-extensions.sh

# Extensions must be installed as the abc user (the one VS Code actually runs as),
# not root, or they won't be picked up / will land with wrong ownership.
USER abc

RUN sudo -u abc /tmp/install-extensions.sh "${VSCODE_EXTENSIONS}"
 
USER root
 
RUN rm -f /tmp/install-extensions.sh

USER root
# ==== description ======
# ENV OPENCODE_INSTALL_DIR=/usr/local/bin
RUN curl -fsSL https://opencode.ai/install | bash
RUN mv /config/.opencode/bin/opencode /usr/local/bin/opencode
RUN chmod +x /usr/local/bin/opencode
RUN rm -rf /config/.opencode


USER abc
RUN command
RUN code --extensions-dir /tmp/extensions --install-extension sst-dev.opencode --force
# RUN code --extensions-dir /tmp/extensions --install-extension sst-dev.opencode-v2 --force
# ==== description ======

USER root
COPY autostart_wayland /defaults/autostart_wayland
