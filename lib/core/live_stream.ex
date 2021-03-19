defmodule MuxWrapper.LiveStream do
  @moduledoc """
  Provides a wrapper of live streaming to manipulate Mux API
  """
  require Logger

  alias MuxWrapper.Casting
  alias MuxWrapper.EmbeddedSchema.{Asset, LiveStream, Simulcast}

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

  @playback_policy %{
    playback_policy: "public",
    new_asset_settings: %{playback_policy: "public"}
  }

  # Live Stream

  @doc """
  Provide a function to send a create a live streming to Mux

  ## Parameters

    - client: provide by `client/0`

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.create_live_stream()
      %MuxWrapper.EmbeddedSchema.LiveStream{
        created_at: ~N[2021-03-16 09:59:26],
        id: "livestream_id_very_long",
        new_asset_settings: %{"playback_policies" => ["public"]},
        playback_ids: [
          %MuxWrapper.EmbeddedSchema.Playback{
            id: "playback_id_very_long",
            policy: "public"
          }
        ],
        reconnect_window: 60,
        status: "idle",
        stream_key: "stream_key_very_long"
      }

  """
  @spec create_live_stream(%Tesla.Client{}) :: %MuxWrapper.EmbeddedSchema.LiveStream{}
  def create_live_stream(client) do
    {:ok, live_stream, _teslaenv} = Mux.Video.LiveStreams.create(client, @playback_policy)

    live_stream
    |> (&Casting.cast(&1, %LiveStream{})).()
  end

  @doc """
  Provide a function to get a specific live streaming from Mux

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.get_live_stream("stream_id_very_long")
      %MuxWrapper.EmbeddedSchema.LiveStream{
        created_at: ~N[2021-03-16 09:59:26],
        id: "stream_id_very_long",
        new_asset_settings: %{"playback_policies" => ["public"]},
        playback_ids: [
          %MuxWrapper.EmbeddedSchema.Playback{
            id: "playback_id_very_long",
            policy: "public"
          }
        ],
        reconnect_window: 60,
        status: "idle",
        stream_key: "stream_key_very_long"
      }

  """
  @spec get_live_stream(%Tesla.Client{}, String.t()) :: %MuxWrapper.EmbeddedSchema.LiveStream{}
  def get_live_stream(client, live_stream_id) do
    {:ok, live_stream, _env} = Mux.Video.LiveStreams.get(client, live_stream_id)

    live_stream
    |> (&Casting.cast(&1, %LiveStream{})).()
  end

  @doc """
  Provide a function to delete a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client |> MuxWrapper.delete_live_stream("live_stream_id_very_long")
      :ok
  """
  @spec delete_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def delete_live_stream(client, live_stream_id) do
    {status, _data, _env} = Mux.Video.LiveStreams.delete(client, live_stream_id)

    status
  end

  @doc """
  Provide a function to enable a live stream

  ## Parameters

  - client: provide by `client/1`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.enable_live_stream("live_stream_id_very_long")
      :ok
  """
  @spec enable_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def enable_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.enable(client, live_stream_id) do
      :ok
    else
      {:error, msg, env} ->
        Logger.error("Mux pass in msg: " <> inspect(msg <> ": " <> List.first(env)))

        :error
    end
  end

  @doc """
  Provide a function to disable a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.disable_live_stream("live_stream_id_very_long")
      :ok


  """
  @spec disable_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def disable_live_stream(client, live_stream_id) do
    {status, _, _env} = Mux.Video.LiveStreams.disable(client, live_stream_id)

    status
  end

  @doc """
  Provide a function to singal a live stream finished

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.complete_live_stream("live_stream_id_very_long")
      :ok

      
  """
  @spec complete_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def complete_live_stream(client, live_stream_id) do
    {status, _, _env} = Mux.Video.LiveStreams.signal_complete(client, live_stream_id)

    status
  end

  @doc """
  Provide a function to list all live streams in Mux, support pagnation see [Mux doc](https://docs.mux.com/api-reference/video#operation/list-live-streams)

   ## Parameters

   - client: provide by `client/0`
   - opt: pagnation query params, can pass a Map like this `%{limit: 10, page: 3}`. If don't pass, the default value from Mux is limit: 25 and page: 1

   ## Example


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
               password: "your_password",
               username: "your_username"
             }
           ]}
        ]
       } 

       iex> MuxWrapper.list_all_live_stream(client, %{limit: 1, page: 1})
       %MuxWrapper.EmbeddedSchema.LiveStream{
         created_at: ~N[2021-03-16 09:59:26],
         id: "livestream_id_very_long",
         new_asset_settings: %{"playback_policies" => ["public"]},
         playback_ids: [
           %MuxWrapper.EmbeddedSchema.Playback{
             id: "playback_id_very_long",
             policy: "public"
           }
         ],
         reconnect_window: 60,
         status: "idle",
         stream_key: "stream_key_very_long"
       }


      
  """
  @spec list_all_live_stream(%Tesla.Client{}, Enum.t()) :: %MuxWrapper.EmbeddedSchema.LiveStream{}
  def list_all_live_stream(client, opt \\ %{}) do
    {:ok, live_streams, _env} = Mux.Video.LiveStreams.list(client, opt)

    live_streams
    |> (&Casting.cast(&1, %LiveStream{})).()
  end

  @doc """
   Provide a function to create a praivate playback id in Mux

   ## Parameters

   - client: provide by `client/0`
   - live_stream_id: live stream id
   - policy_option - provide by `MuxWrapper.EmbeddedSchema.Playback.policy_public/0` or `MuxWrapper.EmbeddedSchema.Playback.policy_private/0`

   ## Example


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
               password: "your_password",
               username: "your_username"
             }
           ]}
        ]
       } 

       iex> MuxWrapper.create_playback_id(client, "stream_id_very_long", :signed)
       %MuxWrapper.EmbeddedSchema.Playback{
         id: "FRDDXsjcNgD013rx1M4CDunZ86xkq8A02hfF3b6XAa7iE",
         policy: "singed"
       }

  """
  @spec create_playback_id(%Tesla.Client{}, String.t(), atom()) ::
          %MuxWrapper.EmbeddedSchema.Playback{}
  def create_playback_id(client, live_stream_id, policy_option) do
    policy_option
    |> create_playback(client, live_stream_id)
    |> Casting.cast_playback()
  end

  defp create_playback(:public, client, live_stream_id) do
    {:ok, playback_id, _env} =
      Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "public"})

    playback_id
  end

  defp create_playback(:private, client, live_stream_id) do
    {:ok, playback_id, _env} =
      Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "signed"})

    playback_id
  end

  @doc """
  Provide a function to delete specfic playback asset from Mux

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id
  - playback_id: play back id

  ## Example


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
              password: "your_password",
              username: "your_username"
            }
          ]}
       ]
      } 

      iex> MuxWrapper.delete_playback_id(client, "stream_id_very_long", "playback_id_very_long")
      :ok
  """
  @spec delete_playback_id(%Tesla.Client{}, String.t(), String.t()) :: atom()
  def delete_playback_id(client, live_stream_id, playback_id) do
    {status, _, _env} =
      Mux.Video.LiveStreams.delete_playback_id(client, live_stream_id, playback_id)

    status
  end

  @doc """
  Provide a function to create simulcast target, strongly suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-live-stream-simulcast-target) first

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id
  - params: request body, `MuxWrapper.EmbeddedSchema.Simulcast`

  ## Example


      iex> params =  %MuxWrapper.EmbeddedSchema.Simulcast{url: "rtmp://live.example.com/app", stream_key: "abcdefgh"}
      %MuxWrapper.EmbeddedSchema.Simulcast{
        id: nil,
        passthrough: nil,
        stream_key: "abcdefgh",
        url: "rtmp://live.example.com/app"
      }

      iex> MuxWrapper.clinet() |> MuxWrapper.create_simulcast_target("live_stream_id_very_long", params)
      %MuxWrapper.EmbeddedSchema.Simulcast{
        id: "vuOfW021mz5QA500wYEQ9SeUYvuYnpFz011mqSvski5T8claN02JN9ve2g",
        passthrough: "Example 1",
        stream_key: "abcdefgh",
        url: "rtmp://live.example1.com/app"
      }

  """
  @spec create_simulcast_target(
          %Tesla.Client{},
          String.t(),
          %MuxWrapper.EmbeddedSchema.Simulcast{}
        ) ::
          %MuxWrapper.EmbeddedSchema.Simulcast{}
  def create_simulcast_target(client, live_stream_id, params) do
    {:ok, simulcast_target, _env} =
      Mux.Video.LiveStreams.create_simulcast_target(client, live_stream_id, params)

    simulcast_target
    |> (&Casting.cast(&1, %Simulcast{})).()
  end

  @doc """
  Provide a function to get simulcast target, strongly suggest read [Mux doc](https://hexdocs.pm/mux/Mux.Video.LiveStreams.html#get_simulcast_target/3) first

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id
  - simulcast_target_id: simulcast target id

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
              password: "your_password",
              username: "your_username"
            }
          ]}
       ]
      } 

      iex> MuxWrapper.get_simulcast_target(client, "stream_id_very_long", "simulcast_target_id")
       %MuxWrapper.EmbeddedSchema.Simulcast{
        id: "vuOfW021mz5QA500wYEQ9SeUYvuYnpFz011mqSvski5T8claN02JN9ve2g",
        passthrough: "Example 1",
        stream_key: "abcdefgh",
        url: "rtmp://live.example1.com/app"
      }


  """
  @spec get_simulcast_target(%Tesla.Client{}, String.t(), String.t()) ::
          %MuxWrapper.EmbeddedSchema.Simulcast{}
  def get_simulcast_target(client, live_stream_id, simulcast_target_id) do
    {:ok, simulcast_target, _env} =
      Mux.Video.LiveStreams.get_simulcast_target(client, live_stream_id, simulcast_target_id)

    simulcast_target
    |> (&Casting.cast(&1, %Simulcast{})).()
  end

  @doc """
  Provide a function to delete simulcast targets

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id
  - simulcast_target_id: simulcast target id

  ## Example


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
              password: "your_password",
              username: "your_username"
            }
          ]}
       ]
      } 

      iex> MuxWrapper.delete_simulcast_target(client, "stream_id_very_long", "simulcast_target_id")
      :ok    
  """
  @spec delete_simulcast_target(%Tesla.Client{}, String.t(), String.t()) :: atom()
  def delete_simulcast_target(client, live_stream_id, simulcast_target_id) do
    {status, _, _env} =
      Mux.Video.LiveStreams.delete_simulcast_target(client, live_stream_id, simulcast_target_id)

    status
  end

  @doc """
  Provide a function to reset stream key

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.reset_stream_key("stream_id_very_long")
      %MuxWrapper.EmbeddedSchema.LiveStream{
        created_at: ~N[2021-03-17 09:27:39],
        id: "009cUTpAr01fQgGQdLHnoy62naafkNhYRGQGTqG6O54kE",
        new_asset_settings: %{"playback_policies" => ["public"]},
        playback_ids: [
          %MuxWrapper.EmbeddedSchema.Playback{
            id: "004iSQFtzMHEPnftHqeU8w6UMwUocP1i8nKXtKlHcjI8",
            policy: "public"
          }
        ],
        reconnect_window: 60,
        status: "disabled",
        stream_key: "d0c30be3-7e80-de52-5676-53a87a02c54f"
      }

  """
  @spec reset_stream_key(%Tesla.Client{}, String.t()) :: %MuxWrapper.EmbeddedSchema.LiveStream{}
  def reset_stream_key(client, live_stream_id) do
    {:ok, live_stream, _env} = Mux.Video.LiveStreams.reset_stream_key(client, live_stream_id)

    live_stream
    |> (&Casting.cast(&1, %LiveStream{})).()
  end

  # Assets
  @spec create_asset(%Tesla.Client{}, Enum.t()) :: %MuxWrapper.EmbeddedSchema.Asset{}
  def create_asset(client, params) do
    {:ok, asset, _env} = Mux.Video.Assets.create(client, params)

    asset
    |> (&Casting.cast(&1, %Asset{})).()
  end
end
