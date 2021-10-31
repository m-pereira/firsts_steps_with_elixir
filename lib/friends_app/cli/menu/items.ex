defmodule FriendsApp.CLI.Menu.Items do
  # same as alias FriendsApp.CLI.Menu, as: Menu
  alias FriendsApp.CLI.Menu

  def all,
    do: [
      %Menu{label: "Create a friend", id: :create},
      %Menu{label: "List your friends", id: :read},
      %Menu{label: "Update a friend", id: :update},
      %Menu{label: "Delete a friend", id: :delete}
    ]
end
