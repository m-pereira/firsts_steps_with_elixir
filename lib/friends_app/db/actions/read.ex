defmodule FriendsApp.Db.Actions.Read do
  import FriendsApp.Db.Actions.Shared, only: [database: 0]

  def perform do
    database()
    |> Scribe.console()
  end
end
