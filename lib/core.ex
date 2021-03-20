defmodule MuxWrapper do
  @moduledoc "Provide shared functions, iex., client()"

  require Logger

  alias MuxWrapper.EmbeddedSchema.{Asset, AssetInfo, LiveStream, Playback, Simulcast}

  @doc """
  Provide a client via authentication

  ## Configuration
  Be sure added this in your **config.exs**

  ```
  config :mux,
    access_token_id: token_id_from_Mux,
    access_token_secret: token_secret_from_Mux
  ```

  ## Examples

      iex> client = MuxWrapper.client()
      %Tesla.Client{
        adapter: nil,
        fun: nil,
        post: [],
        pre: [
          {Tesla.Middleware.BaseUrl, :call, ["https://api.mux.com"]},
          {Tesla.Middleware.BasicAuth, :call,
           [
             %{
               password: "YOUR_PASSWORD",
               username: "YOUR_USERNAME"
             }
           ]}
        ]
      }
  """
  @spec client :: %Tesla.Client{}
  def client,
    do:
      Mux.client(
        Application.get_env(:mux, :access_token_id),
        Application.get_env(:mux, :access_token_secret)
      )

  def cast(list, %LiveStream{} = struct) when is_list(list) do
    live_streams =
      list
      |> Enum.map(&cast(&1, struct))

    {:ok, live_streams}
  end

  def cast(map, %LiveStream{} = struct), do: {:ok, LiveStream.cast(struct, map)}
  def cast(map, %Asset{} = struct), do: {:ok, Asset.cast(struct, map)}
  def cast(map, %AssetInfo{} = struct), do: {:ok, AssetInfo.cast(struct, map)}
  def cast(map, %Playback{} = struct), do: {:ok, Playback.cast(struct, map)}
  def cast(map, %Simulcast{} = struct), do: {:ok, Simulcast.cast(struct, map)}

  @doc false
  def print_errors(reason, details) do
    Logger.error("Mux pass in msg: " <> inspect(reason <> ": " <> List.first(details)))

    {:error}
  end
end
