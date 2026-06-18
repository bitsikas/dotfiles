FROM debian:bookworm-slim


RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git sudo xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash -d /home/kp kp \
    && echo "kp ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kp;


USER kp
ENV USER=kp
ENV PATH="/home/kp/.nix-profile/bin:/home/kp/.local/state/nix/profiles/profile/bin:${PATH}"

RUN set -eux \
 && curl -L https://nixos.org/nix/install | sh -s -- --no-daemon \
 && . /home/kp/.nix-profile/etc/profile.d/nix.sh \
 && mkdir -p /home/kp/.config/nix \
 && echo "experimental-features = nix-command flakes" > /home/kp/.config/nix/nix.conf;

COPY --chown=kp:kp . /home/kp/dotfiles

RUN cd /home/kp/dotfiles \
 && nix build .#homeConfigurations.aarch64cli.activationPackage --no-link \
 && "$(nix path-info .#homeConfigurations.aarch64cli.activationPackage)"/activate \
 && nix store gc \
 && nix-collect-garbage -d;

RUN rm -rf /home/kp/dotfiles

COPY --chown=kp:kp entrypoint.sh /home/kp/entrypoint.sh

WORKDIR /home/kp
ENTRYPOINT ["/home/kp/entrypoint.sh"]
CMD ["fish"]
