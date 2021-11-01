defmodule FriendsApp.Db.CSV do
  alias Mix.Shell.IO, as: Shell
  alias FriendsApp.CLI.Menu
  alias FriendsApp.CLI.Friend
  alias NimbleCSV.RFC4180, as: Parser

  def perform(item) do
    case item do
      %Menu{id: :create, label: _} -> create()
      %Menu{id: :read, label: label} -> Shell.info(label)
      %Menu{id: :update, label: label} -> Shell.info(label)
      %Menu{id: :delete, label: label} -> Shell.info(label)
    end

    FriendsApp.CLI.Controller.start()
  end

  defp create do
    collect_data()
    |> Keyword.values()
    |> wrap()
    |> Parser.dump_to_iodata()
    |> save_csv()
  end

  defp collect_data do
    Shell.cmd("clear")

    # Keyword list
    [
      name: prompt("Name:"),
      email: prompt("Email:"),
      phone: prompt("Phone:")
    ]
  end

  defp save_csv(data) do
    File.write!("#{File.cwd!()}/friends.csv", data, [:append])
  end

  defp prompt(message) do
    Shell.prompt(message) |> String.trim()
  end

  defp wrap(list) do
    [list]
  end
end
