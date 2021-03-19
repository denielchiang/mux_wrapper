defmodule MuxWrapper.Type.UnixEpoch do
  @moduledoc false
  use Ecto.Type

  def type, do: :naive_datetime

  def cast(unix_epoch_time) when is_binary(unix_epoch_time) do
    cast(String.to_integer(unix_epoch_time))
  end

  def cast(unix_epoch_time) when is_integer(unix_epoch_time) do
    {:ok, transform_to_naive(unix_epoch_time)}
  end

  def cast(_), do: :error

  def dump(unix_epoch_time) when is_binary(unix_epoch_time), do: {:ok}
  def dump(unix_epoch_time) when is_integer(unix_epoch_time), do: {:ok}

  def load(unix_epoch_time) when is_binary(unix_epoch_time) do
    load(String.to_integer(unix_epoch_time))
  end

  def load(unix_epoch_time) when is_integer(unix_epoch_time) do
    {:ok, transform_to_naive(unix_epoch_time)}
  end

  defp transform_to_naive(unix_epoch_time) do
    unix_epoch_time
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end
end
