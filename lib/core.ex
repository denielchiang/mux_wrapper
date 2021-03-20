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

  @doc false
  def cast(list, %LiveStream{} = struct) when is_list(list),
    do: Enum.map(list, &cast(&1, struct))

  def cast(map, %Asset{} = struct), do: Asset.cast(struct, map)
  def cast(map, %AssetInfo{} = struct), do: AssetInfo.cast(struct, map)
  def cast(map, %LiveStream{} = struct), do: LiveStream.cast(struct, map)
  def cast(map, %Playback{} = struct), do: Playback.cast(struct, map)
  def cast(map, %Simulcast{} = struct), do: Simulcast.cast(struct, map)

  @doc false
  def cast_playback(playback_id), do: playback_id |> (&cast(&1, %Playback{})).()

  @doc false
  def print_errors(reason, details),
    do: Logger.error("Mux pass in msg: " <> inspect(reason <> ": " <> List.first(details)))
end
