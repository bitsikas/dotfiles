# This is meant to run from docker nixos/nix
# assuming we've mounted the ssh auth sock
# in our case with colima it's something like
# colima start --ssh-agent
# set COLIMA_SSH_AUTH_SOCK $(colima ssh eval 'echo $SSH_AUTH_SOCK')
# docker run -it --rm -v $HOME/.ssh/config.d:/root/.ssh/config.d -v $PWD:/workspace -w /workspace -v $COLIMA_SSH_AUTH_SOCK:$COLIMA_SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$COLIMA_SSH_AUTH_SOCK nixos/nix:latest bash -it infect.sh <some_server> 
# server usually is something like an ec2 with kexec-tools installed
#
echo "Include config.d/*" > /root/.ssh/config
echo "filter-syscalls = false" >> /etc/nix/nix.conf

nix run --extra-experimental-features nix-command --extra-experimental-features flakes  github:nix-community/nixos-anywhere -- --flake .#devserver --target-host "$1"
