# Halt in case of errors. https://gist.github.com/vncsna/64825d5609c146e80de8b1fd623011ca
set -eo pipefail
echo "[TEMPLATE INFO] Running entrypoint.sh"

# Check that the NAS_HOME is set.
if [ -z "${NAS_HOME}" ]; then
  echo "[TEMPLATE WARNING] NAS_HOME is not set."
  echo "[TEMPLATE WARNING] It is expected to point to the location of your mounted  project."
  echo "[TEMPLATE WARNING] It has been defaulted to $(pwd)"
  NAS_HOME="$(pwd)"
  export NAS_HOME
else
  echo "[TEMPLATE INFO] NAS_HOME is set to ${NAS_HOME}."
fi

# Remote development options (e.g., PyCharm or VS Code configuration, Jupyter etc).
# Doesn't do anything if no option provided.
zsh "${ENTRYPOINTS_ROOT}"/remote-development-setup.sh

# Login options, e.g., wandb.
# Doesn't do anything if no option provided.
zsh "${ENTRYPOINTS_ROOT}"/logins-setup.sh

# Run the rest from the project root.
# This is set in the entrypoint and not in the Dockerfile as a Workdir
# to accommodate deployment options which can't mount subdirectories to specific locations.
# (so we cannot assume a predefined location for the project).
echo "[TEMPLATE INFO] The next commands (and all interactive shells) will be run from ${NAS_HOME}."
cd "${NAS_HOME}"
# export HOME=$NAS_HOME

# Exec so that the child process receives the OS signals.
# E.g., signals that the container will be preempted.
# It will be PID 1.
echo "[TEMPLATE INFO] Executing the command" "$@"
exec "$@"
