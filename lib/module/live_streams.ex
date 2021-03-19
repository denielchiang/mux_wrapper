defmodule MuxWrapper.LiveStreams do
  @moduledoc """
  Provides a wrapper of live streaming to manipulate Mux API
  """

  alias MuxWrapper
  alias MuxWrapper.EmbeddedSchema.{LiveStream, Simulcast}

  @playback_policy %{
    playback_policy: "public",
    new_asset_settings: %{playback_policy: "public"}
  }

  @doc """
  Provide a function to send a create a live streming to Mux

  ## Parameters

    - client: provide by `MuxWrapper.client/0`

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.create_live_stream()
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
    with {:ok, live_stream, _teslaenv} <- Mux.Video.LiveStreams.create(client, @playback_policy) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to get a specific live streaming from Mux

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.get_live_stream("stream_id_very_long")
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
    with {:ok, live_stream, _env} <- Mux.Video.LiveStreams.get(client, live_stream_id) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to delete a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client |> MuxWrapper.LiveStreams.delete_live_stream("live_stream_id_very_long")
      :ok
  """
  @spec delete_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def delete_live_stream(client, live_stream_id) do
    with {:ok, _data, _env} <- Mux.Video.LiveStreams.delete(client, live_stream_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to enable a live stream

  ## Parameters

  - client: provide by `client/1`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.enable_live_stream("live_stream_id_very_long")
      :ok
  """
  @spec enable_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def enable_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.enable(client, live_stream_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to disable a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.disable_live_stream("live_stream_id_very_long")
      :ok


  """
  @spec disable_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def disable_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.disable(client, live_stream_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to singal a live stream finished

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.complete_live_stream("live_stream_id_very_long")
      :ok

      
  """
  @spec complete_live_stream(%Tesla.Client{}, String.t()) :: atom()
  def complete_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.signal_complete(client, live_stream_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
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

       iex> MuxWrapper.LiveStreams.list_all_live_stream(client, %{limit: 1, page: 1})
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
    with {:ok, live_streams, _env} <- Mux.Video.LiveStreams.list(client, opt) do
      live_streams
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
   Provide a function to create a praivate playback id in Mux

   ## Parameters

   - client: provide by `client/0`
   - live_stream_id: live stream id
   - pramas - provide by `MuxWrapper.EmbeddedSchema.Playback.policy_public/0` or `MuxWrapper.EmbeddedSchema.Playback.policy_private/0`

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

       iex> MuxWrapper.LiveStreams.create_playback_id(client, "stream_id_very_long", :signed)
       %MuxWrapper.EmbeddedSchema.Playback{
         id: "FRDDXsjcNgD013rx1M4CDunZ86xkq8A02hfF3b6XAa7iE",
         policy: "singed"
       }

  """
  @spec create_playback_id(%Tesla.Client{}, String.t(), atom()) ::
          %MuxWrapper.EmbeddedSchema.Playback{}
  def create_playback_id(client, live_stream_id, params) do
    with {:ok, playback_id} <- create_playback(params, client, live_stream_id) do
      MuxWrapper.cast_playback(playback_id)
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  defp create_playback(:public, client, live_stream_id) do
    with {:ok, playback_id, _env} <-
           Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "public"}) do
      {:ok, playback_id}
    else
      {:error, reason, details} ->
        {:error, reason, details}
    end
  end

  defp create_playback(:private, client, live_stream_id) do
    with {:ok, playback_id, _env} <-
           Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "signed"}) do
      {:ok, playback_id}
    else
      {:error, reason, details} ->
        {:error, reason, details}
    end
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

      iex> MuxWrapper.LiveStreams.delete_playback_id(client, "stream_id_very_long", "playback_id_very_long")
      :ok
  """
  @spec delete_playback_id(%Tesla.Client{}, String.t(), String.t()) :: atom()
  def delete_playback_id(client, live_stream_id, playback_id) do
    with {:ok, _, _env} <-
           Mux.Video.LiveStreams.delete_playback_id(client, live_stream_id, playback_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
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

      iex> MuxWrapper.clinet() |> MuxWrapper.LiveStreams.create_simulcast_target("live_stream_id_very_long", params)
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
    with {:ok, simulcast_target, _env} <-
           Mux.Video.LiveStreams.create_simulcast_target(client, live_stream_id, params) do
      simulcast_target
      |> (&MuxWrapper.cast(&1, %Simulcast{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
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

      iex> MuxWrapper.LiveStreams.get_simulcast_target(client, "stream_id_very_long", "simulcast_target_id")
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
    with {:ok, simulcast_target, _env} <-
           Mux.Video.LiveStreams.get_simulcast_target(client, live_stream_id, simulcast_target_id) do
      simulcast_target
      |> (&MuxWrapper.cast(&1, %Simulcast{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
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

      iex> MuxWrapper.LiveStreams.delete_simulcast_target(client, "stream_id_very_long", "simulcast_target_id")
      :ok    
  """
  @spec delete_simulcast_target(%Tesla.Client{}, String.t(), String.t()) :: atom()
  def delete_simulcast_target(client, live_stream_id, simulcast_target_id) do
    with {:ok, _, _env} <-
           Mux.Video.LiveStreams.delete_simulcast_target(
             client,
             live_stream_id,
             simulcast_target_id
           ) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide a function to reset stream key

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.reset_stream_key("stream_id_very_long")
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
    with {:ok, live_stream, _env} <-
           Mux.Video.LiveStreams.reset_stream_key(client, live_stream_id) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end
end