
FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-bootc:44

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf -y copr enable horizonproject/fernsehen && \
    dnf -y update && \
    dnf install -y \
        plasma-bigscreen-git \
        plasma-setup \
        plasma-login-manager \
        konsole \
        flathub && \
    curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
    
RUN bootc container lint
