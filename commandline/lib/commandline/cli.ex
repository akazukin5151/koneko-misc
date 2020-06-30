defmodule Consumer do
  def init(display) do
    loop([], display, [], 0..29 |> Enum.to_list)
  end

  defp loop(downloaded, display, paths, []), do: :ok

  defp loop(downloaded, display, paths, [head | tail]) do
    nextnum = head

    cond do
      nextnum in downloaded ->
        # Send to display "channel"
        display |> send(nextnum |> int_to_file(paths))

        # Inspect next accepted number in order
        downloaded
        |> remove_int(nextnum)
        |> loop(display, paths |> remove_file(nextnum), tail)

      true ->
        :ok
    end

    # On receiving a completed download, store the number in the filename
    receive do
      msg ->
        msg
        |> file_to_int
        |> append(downloaded)
        |> loop(display, msg |> append(paths), [head | tail])
    end
  end

  defp append(image, list) do
    [image | list]
  end

  defp remove_int(list, number) do
    Enum.filter(list, fn x -> x != number end)
  end

  def remove_file(list, number) do
    Enum.filter(list, fn x -> file_to_int(x) != number end)
  end

  defp int_to_file(number, paths) do
    Enum.filter(paths, fn x -> file_to_int(x) == number end)
  end

  def file_to_int(path) do
    String.slice(path, 0..2) |> String.to_integer
  end
end

defmodule Producer do
  def init(files, display) do
    pid = spawn(fn -> Consumer.init(display) end)
    Enum.map(files, fn x -> pid |> send(x) end)
  end
end

defmodule Display do
  def init do
    left_shifts = %{0 => 2, 1 => 20, 2 => 38, 3 => 56, 4 => 74}
    rowspaces = %{0 => 0, 1 => 9}
    loop(left_shifts, rowspaces)
  end

  defp loop(left_shifts, rowspaces) do
    receive do
      image ->
        image
        |> hd
        |> IO.inspect(label: "image")

        num =
          image
          |> hd
          |> Consumer.file_to_int

        x = num |> rem(5)
        y = num |> div(5) |> rem(2)

        left_shifts[x] |> IO.inspect(label: "x")
        rowspaces[y] |> IO.inspect(label: "y")
    end

    loop(left_shifts, rowspaces)
  end
end

defmodule Commandline.CLI do
  def main(_args) do
    display = spawn(fn -> Display.init end)
    files = "~/.local/share/koneko/cache/2232374/1/"
    files |> Path.expand |> File.ls! |> Producer.init(display)
    # So that the Display has time to print everything
    Process.sleep(100)
  end
end

# icat wouldn't work because of something about ports and the wrong tty
# :os.cmd('kitty +kitten icat ~/.local/share/koneko/cache/2232374/1/') |> IO.puts
# System.cmd("kitty", ["+kitten", "icat", "~/.local/share/koneko/cache/2232374/1/"])
