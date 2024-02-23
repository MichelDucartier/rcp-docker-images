## VS Code remote development server.
if [ -n "${VSCODE_CONFIG_AT}" ]; then
  echo "[TEMPLATE INFO] Sym-linking to VSCode server config files."
  ln -s "${VSCODE_CONFIG_AT}" "${HOME}/.vscode-server"
fi
