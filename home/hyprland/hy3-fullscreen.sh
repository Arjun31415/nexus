ActiveWorkspace="$(hyprctl activeworkspace -j | jaq .id)"
ActiveWorkspaceClients="$(hyprctl clients -j | jaq ".[]| select(.workspace.id == $ActiveWorkspace) ")"
ActiveWorkspaceClientsCount="$(jaq -s "length" <<< $ActiveWorkspaceClients)"
ActiveWorkspaceHiddenCount="$(jaq "select(.hidden == true) | length" <<< $ActiveWorkspaceClients | wc -l)"
ActiveWorkspaceVisbleCount="$(jaq "select(.hidden == false) | length" <<< $ActiveWorkspaceClients | wc -l)"
TabbedCount="$(jaq "[.at, .size] " <<< $ActiveWorkspaceClients | jq -s 'group_by(.) | map(select(length > 1)) | map(length) | add')"

if [ "$ActiveWorkspaceHiddenCount" -gt 0 ] ; then
  if [ "$TabbedCount" = null ]; then
    hyprctl dispatch hy3:expand base
  elif [ "$ActiveWorkspaceHiddenCount" -lt "$TabbedCount" ]; then
    for (( c=1; c<=ActiveWorkspaceVisbleCount; c++ ))
    do
      hyprctl dispatch hy3:expand expand
    done
  else
    hyprctl dispatch hy3:expand base
  fi
elif [ "$ActiveWorkspaceClientsCount" -gt 0 ]; then
  for (( c=1; c<=ActiveWorkspaceClientsCount; c++ ))
  do
    hyprctl dispatch hy3:expand expand
  done
fi
