defmodule FriendsApp.Db.CSV do
  alias Mix.Shell.IO, as: Shell
  alias FriendsApp.CLI.Menu
  alias FriendsApp.CLI.Friend
  alias NimbleCSV.RFC4180, as: Parser

  def perform(item) do
    case item do
      %Menu{id: :create, label: _} -> create()
      %Menu{id: :read, label: _} -> read()
      %Menu{id: :update, label: label} -> Shell.info(label)
      %Menu{id: :delete, label: label} -> Shell.info(label)
    end

    FriendsApp.CLI.Controller.start()
  end

  defp create do
    collect_data()
    |> to_csv()
    |> Parser.dump_to_iodata()
    |> save_csv([:append])
  end

  def read do
    read_db_file()
    |> Parser.parse_string(headers: false)
    |> Enum.map(&to_friend(&1))
    |> Scribe.console()
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

  defp read_db_file do
    Application.fetch_env!(:friends_app, :db_file_path)
    |> File.read!()
  end

  defp to_friend([name, email, phone]) do
    %Friend{name: name, email: email, phone: phone}
  end

  defp to_csv(keyword_list) do
    keyword_list
    |> Keyword.values()
    |> Kernel.then(fn list -> [list] end)
  end

  defp save_csv(data, mode \\ []) do
    Application.fetch_env!(:friends_app, :db_file_path)
    |> File.write!(data, mode)
  end

  defp prompt(message) do
    Shell.prompt(message) |> String.trim()
  end
end
