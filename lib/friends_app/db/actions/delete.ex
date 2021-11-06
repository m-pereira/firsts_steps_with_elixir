defmodule FriendsApp.Db.Actions.Delete do
  alias Mix.Shell.IO, as: Shell

  import FriendsApp.Db.Actions.Shared,
    only: [
      prompt: 1,
      find_friend_by: 1,
      check_presence: 1,
      show_and_confirm: 2,
      delete_and_save: 1
    ]

  def perform do
    Shell.cmd("clear")

    prompt("Enter friend email to be deleted:")
    |> find_friend_by()
    |> check_presence()
    |> show_and_confirm("Friend to be deleted:")
    |> delete_and_save()
  end
end
