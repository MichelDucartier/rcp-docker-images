# Set WANDB_API_KEY_FILE_AT in the environment which points to a file containing the key.
if [ -n "${WANDB_API_KEY_FILE_AT}" ]; then
  echo "[TEMPLATE INFO] Logging in to W&B."
  wandb login "$(cat "${WANDB_API_KEY_FILE_AT}")"
fi

# Set HF_API_KEY_FILE_AT in the environment which points to a file containing the key.
if [ -n "${HF_API_KEY_FILE_AT}" ]; then
  echo "[TEMPLATE INFO] Logging in to Hugging Face."
  huggingface-cli login --token "$(cat "${HF_API_KEY_FILE_AT}")"
fi

# Sym-link git config files
if [ -n "${GITCONFIG_AT}" ]; then
  echo "[TEMPLATE INFO] Sym-linking to GIT config files."
  ln -s "${GITCONFIG_AT}" "${HOME}/.gitconfig"
fi

# Sym-link git credentials config files
if [ -n "${GIT_CREDENTIALS_AT}" ]; then
  echo "[TEMPLATE INFO] Sym-linking to GIT Credentials config files."
  ln -s "${GIT_CREDENTIALS_AT}" "${HOME}/.git-credentials "
fi