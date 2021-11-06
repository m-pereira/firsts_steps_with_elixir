defmodule FriendsApp.Db.Actions.Create do
  import FriendsApp.Db.Actions.Shared, only: [collect_data: 0, to_csv: 1, save_csv: 2]

  def perform do
    collect_data()
    |> to_csv()
    |> save_csv([:append])
  end
end
