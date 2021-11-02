defmodule Mix.Tasks.Utils.AddFakeFriends do
  use Mix.Task

  @shortdoc "Add fake friends to app"
  def run(_) do
    Faker.start()

    create_friends([], 50)
    |> NimbleCSV.RFC4180.dump_to_iodata()
    |> save_csv()
  end

  defp create_friends(list, count) when count <= 1 do
    list ++ [ramdom_friend()]
  end

  defp create_friends(list, count) do
    list ++ [ramdom_friend()] ++ create_friends(list, count - 1)
  end

  defp ramdom_friend do
    [Faker.Person.name(), Faker.Internet.email(), Faker.Phone.EnUs.phone()]
  end

  defp save_csv(data) do
    Application.fetch_env!(:friends_app, :db_file_path)
    |> File.write!(data, [:append])
  end
end
