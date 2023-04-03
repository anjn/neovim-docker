set -x

export USER=$USER
export HOME=/home/$USER
export LOGNAME=$USER
export PATH=/usr/local/bin:/bin:/usr/bin

export XDG_DATA_HOME=/xdg/local/share
export XDG_CONFIG_HOME=/xdg/config 
export XDG_STATE_HOME=/xdg/local/state
export XDG_CACHE_HOME=/xdg/cache

dir=$1 ; shift
cd "$dir"

exec setpriv --reuid=$USER --regid=$USER --init-groups /usr/bin/nvim "$@"

