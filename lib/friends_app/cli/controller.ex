defmodule FriendsApp.CLI.Controller do
  def start, do: FriendsApp.CLI.Menu.Choice.start()

  def process(item) do
    FriendsApp.Db.CSV.perform(item)
  end
end
