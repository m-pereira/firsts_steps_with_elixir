defmodule FriendsApp.CLI.Menu.Choice do
  alias Mix.Shell.IO, as: Shell
  alias FriendsApp.CLI.Menu.Items

  @first_item_char 1

  def start do
    Shell.cmd("clear")
    Shell.info("Choose an option:")

    menu_items = Items.all()
    find_menu_item_by_index = &Enum.at(menu_items, &1, :error)

    menu_items
    |> Enum.map(& &1.label)
    |> display()
    |> generate_question_for()
    |> Shell.prompt()
    |> parse()
    |> find_menu_item_by_index.()
    |> confirmation_step()
    |> confirmation_of()
    |> FriendsApp.CLI.Controller.process()
  end

  defp display(options) do
    options
    |> Enum.with_index(@first_item_char)
    # [{"Create", 1}, {"Update", 2}, ...]
    |> Enum.each(fn {op, index} -> Shell.info("#{index} - #{op}") end)

    options
  end

  defp generate_question_for(options) do
    options = @first_item_char..Enum.count(options) |> Enum.join(", ")

    "Choose an option (#{options}): \n"
  end

  defp parse(option) do
    case Integer.parse(option) do
      :error -> handle("Invalid option")
      {0, _} -> handle("Invalid option")
      {option, _} -> option - @first_item_char
    end
  end

  defp confirmation_of(item) do
    Shell.cmd("clear")
    Shell.info("You chose #{item.label}")

    case Shell.yes?("Are you sure?") do
      true -> item
      false -> start()
    end
  end

  defp confirmation_step(chosen_menu_item) do
    case chosen_menu_item do
      :error -> handle("Invalid option")
      _ -> chosen_menu_item
    end
  end

  defp handle(error) do
    Shell.cmd("clear")
    Shell.error(error)
    Shell.prompt("Press enter to try again")

    start()
  end
end
