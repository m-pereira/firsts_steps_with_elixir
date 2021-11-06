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
      %Menu{id: :delete, label: _} -> delete()
    end

    FriendsApp.CLI.Controller.start()
  end

  defp create do
    collect_data()
    |> to_csv()
    |> IO.inspect()
    |> save_csv([:append])
  end

  defp read do
    database()
    |> Scribe.console()
  end

  defp delete do
    Shell.cmd("clear")

    prompt("Enter friend email to be deleted:")
    |> find_friend_by()
    |> check_presence()
    |> show_and_confirm()
    |> delete_and_save()
  end

  defp database do
    Application.fetch_env!(:friends_app, :db_file_path)
    |> File.read!()
    |> Parser.parse_string(headers: false)
    |> Enum.map(&to_friend(&1))
  end

  defp delete_and_save(friend) do
    case friend do
      %Friend{name: _, email: _, phone: _} ->
        database()
        # friend is the second parameter, first is the collection
        |> destroy(friend)
        |> to_csv()
        |> save_csv()

        Shell.info("Friend was successfuly deleted")
        Shell.prompt("Press enter to continue")

      _ ->
        Shell.info("Ok, do not delete friend...")
        Shell.prompt("Press enter to continue")
    end
  end

  defp destroy(list, friend) do
    list
    |> Enum.reject(fn f -> f.email == friend.email end)
  end

  defp find_friend_by(email) do
    database() |> Enum.find(fn friend -> friend.email == email end)
  end

  defp check_presence(friend) do
    case friend do
      nil ->
        Shell.cmd("clear")
        Shell.error("Friend not found")
        Shell.prompt("Press enter to continue...")
        FriendsApp.CLI.Controller.start()

      _ ->
        friend
    end
  end

  defp show_and_confirm(friend) do
    Shell.cmd("clear")
    Shell.info("Friend to be deleted:")

    Scribe.print(friend)

    case Shell.yes?("Are you sure?") do
      true -> friend
      false -> nil
    end
  end

  defp to_friend([name, email, phone]) do
    %Friend{name: name, email: email, phone: phone}
  end

  defp to_csv(element) do
    # this can be a structs list, a keyword list or even a list of lists
    [element]
    |> List.flatten()
    |> Enum.map(&csv_of(&1))
  end

  defp csv_of(element) do
    case element do
      %Friend{name: name, email: email, phone: phone} ->
        [name, email, phone]

      [name: name, email: email, phone: phone] ->
        [name, email, phone]

      _ ->
        element
    end
  end

  defp collect_data do
    Shell.cmd("clear")

    %Friend{
      name: prompt("Name:"),
      email: prompt("Email:"),
      phone: prompt("Phone:")
    }
  end

  defp save_csv(data, mode \\ []) do
    Application.fetch_env!(:friends_app, :db_file_path)
    |> File.write!(Parser.dump_to_iodata(data), mode)
  end

  defp prompt(message) do
    Shell.prompt(message) |> String.trim()
  end
end
