defmodule FriendsApp.Db.CSV do
  alias FriendsApp.CLI.Menu

  def perform(item) do
    strategy =
      case item do
        %Menu{id: :create, label: _} -> FriendsApp.Db.Actions.Create
        %Menu{id: :read, label: _} -> FriendsApp.Db.Actions.Read
        %Menu{id: :update, label: _} -> FriendsApp.Db.Actions.Update
        %Menu{id: :delete, label: _} -> FriendsApp.Db.Actions.Delete
      end

    strategy.perform()
    FriendsApp.CLI.Controller.start()
  end
end
