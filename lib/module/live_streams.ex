defmodule MuxWrapper.LiveStreams do
  @moduledoc """
  Provides a wrapper of live streaming to manipulate Mux API
  """

  alias MuxWrapper.EmbeddedSchema.{LiveStream, Simulcast, Playback}

  @privacy %{
    public: "public",
    private: "signed"
  }

  @doc """
  Provide a function to send a create a live streming to Mux

  ## Parameters

    - client: provide by `MuxWrapper.client/0`

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.create_live_stream()
      {:ok, 
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
      }


  """
  @spec create_live_stream(%Tesla.Client{}) :: tuple()
  def create_live_stream(client) do
    with {:ok, live_stream, _teslaenv} <-
           Mux.Video.LiveStreams.create(client, %{policy: @privacy.public}) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to get a specific live streaming from Mux

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.get("stream_id_very_long")
      {:ok,
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
      }

  """
  @spec get(%Tesla.Client{}, String.t()) :: tuple()
  def get(client, live_stream_id) do
    with {:ok, live_stream, _env} <- Mux.Video.LiveStreams.get(client, live_stream_id) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to delete a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client |> MuxWrapper.LiveStreams.delete_live_stream("live_stream_id_very_long")
      {:ok}
  """
  @spec delete_live_stream(%Tesla.Client{}, String.t()) :: tuple()
  def delete_live_stream(client, live_stream_id) do
    with {:ok, _data, _env} <- Mux.Video.LiveStreams.delete(client, live_stream_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to enable a live stream

  ## Parameters

  - client: provide by `client/1`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.enable_live_stream("live_stream_id_very_long")
      {:ok}
  """
  @spec enable_live_stream(%Tesla.Client{}, String.t()) :: tuple()
  def enable_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.enable(client, live_stream_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to disable a live stream

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.disable_live_stream("live_stream_id_very_long")
      {:ok}


  """
  @spec disable_live_stream(%Tesla.Client{}, String.t()) :: tuple()
  def disable_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.disable(client, live_stream_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to singal a live stream finished

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.complete_live_stream("live_stream_id_very_long")
      {:ok}

      
  """
  @spec complete_live_stream(%Tesla.Client{}, String.t()) :: tuple()
  def complete_live_stream(client, live_stream_id) do
    with {:ok, _, _env} <- Mux.Video.LiveStreams.signal_complete(client, live_stream_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to list live streams by passing params in Mux, support pagnation see [Mux doc](https://docs.mux.com/api-reference/video#operation/list-live-streams)

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

       iex> MuxWrapper.LiveStreams.list(client, %{limit: 1, page: 1})
       {:ok, 
         [
          %MuxWrapper.EmbeddedSchema.LiveStream{
            created_at: ~N[2021-03-17 16:49:36],
            id: "ABYT7nZXRKXLz02rMeWo00bhzLgw34sby6ZcZWR7vboFI",
            new_asset_settings: %{"playback_policies" => ["public"]},
            playback_ids: [
              %MuxWrapper.EmbeddedSchema.Playback{
                id: "NbUxpgpd02V00g02JNScdJwCxB9LUzPlvUmcnGHadG1V700",
                policy: "public"
              },
              %MuxWrapper.EmbeddedSchema.Playback{
                id: "Lg2lOeX9dmuzGOZBRVPYhcng9008MPUcCxwWA8002brlw",
                policy: "signed"
              },
              %MuxWrapper.EmbeddedSchema.Playback{
                id: "cnIcHj02pOmG01aTAE7t2B5iDWjWgQgLUbz8YHkJElBcs",
                policy: "public"
              }
            ],
            reconnect_window: 60,
            status: "idle",
            stream_key: "stream_key_very_long"
          }
         ] 
       }

      
  """
  @spec list(%Tesla.Client{}, Enum.t()) :: tuple()
  def list(client, opt \\ %{}) do
    with {:ok, live_streams, _env} <- Mux.Video.LiveStreams.list(client, opt) do
      live_streams
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Create a `public` new playback ID by asset id. to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-asset-playback-id) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - live_stream_id - live stream id

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

      iex> MuxWrapper.Playbacks.create_public_playback_id(client, "live_stream_id_very_long")
      {:ok,
        %MuxWrapper.EmbeddedSchema.Playback{
          id: "UdNWaprxjIA01BUYYDJpaCiDZQu22Ep6tAJLOLA8Sk7A",
          policy: "public"
        }
      }


  """
  @spec create_public_playback_id(%Tesla.Client{}, String.t()) :: tuple()
  def create_public_playback_id(client, live_stream_id),
    do: create_playback_id(client, live_stream_id, %{policy: @privacy.public})

  @doc """
  Create a `signed` new playback ID by asset id. to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-asset-playback-id) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - live_stream_id - live stream id

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

      iex> MuxWrapper.Playbacks.create_private_playback_id(client, "live_stream_id_very_long")
      {:ok,
        %MuxWrapper.EmbeddedSchema.Playback{
          id: "yP29YfRnmqr6Ft47nd9FscOTq5Eo63UWB74TJSeo9Es",
          policy: "signed"
        } 
      }


  """
  @spec create_private_playback_id(%Tesla.Client{}, String.t()) :: tuple()
  def create_private_playback_id(client, live_stream_id),
    do: create_playback_id(client, live_stream_id, %{policy: @privacy.private})

  defp create_playback_id(client, live_stream_id, params) do
    with {:ok, playback_id, _env} <-
           Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, params) do
      playback_id
      |> (&MuxWrapper.cast(&1, %Playback{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok}
  """
  @spec delete_playback_id(%Tesla.Client{}, String.t(), String.t()) :: tuple()
  def delete_playback_id(client, live_stream_id, playback_id) do
    with {:ok, _, _env} <-
           Mux.Video.LiveStreams.delete_playback_id(client, live_stream_id, playback_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok, 
        %MuxWrapper.EmbeddedSchema.Simulcast{
          id: "vuOfW021mz5QA500wYEQ9SeUYvuYnpFz011mqSvski5T8claN02JN9ve2g",
          passthrough: "Example 1",
          stream_key: "abcdefgh",
          url: "rtmp://live.example1.com/app"
        }
      }

  """
  @spec create_simulcast_target(
          %Tesla.Client{},
          String.t(),
          %MuxWrapper.EmbeddedSchema.Simulcast{}
        ) :: tuple()
  def create_simulcast_target(client, live_stream_id, params) do
    with {:ok, simulcast_target, _env} <-
           Mux.Video.LiveStreams.create_simulcast_target(client, live_stream_id, params) do
      simulcast_target
      |> (&MuxWrapper.cast(&1, %Simulcast{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok, 
        %MuxWrapper.EmbeddedSchema.Simulcast{
          id: "vuOfW021mz5QA500wYEQ9SeUYvuYnpFz011mqSvski5T8claN02JN9ve2g",
          passthrough: "Example 1",
          stream_key: "abcdefgh",
          url: "rtmp://live.example1.com/app"
        }
      }


  """
  @spec get_simulcast_target(%Tesla.Client{}, String.t(), String.t()) :: tuple()
  def get_simulcast_target(client, live_stream_id, simulcast_target_id) do
    with {:ok, simulcast_target, _env} <-
           Mux.Video.LiveStreams.get_simulcast_target(client, live_stream_id, simulcast_target_id) do
      simulcast_target
      |> (&MuxWrapper.cast(&1, %Simulcast{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok}
  """
  @spec delete_simulcast_target(%Tesla.Client{}, String.t(), String.t()) :: tuple()
  def delete_simulcast_target(client, live_stream_id, simulcast_target_id) do
    with {:ok, _, _env} <-
           Mux.Video.LiveStreams.delete_simulcast_target(
             client,
             live_stream_id,
             simulcast_target_id
           ) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a function to reset stream key

  ## Parameters

  - client: provide by `client/0`
  - live_stream_id: live stream id

  ## Examples


      iex> MuxWrapper.client() |> MuxWrapper.LiveStreams.reset_stream_key("stream_id_very_long")
      {:ok, 
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
      }


  """
  @spec reset_stream_key(%Tesla.Client{}, String.t()) :: tuple()
  def reset_stream_key(client, live_stream_id) do
    with {:ok, live_stream, _env} <-
           Mux.Video.LiveStreams.reset_stream_key(client, live_stream_id) do
      live_stream
      |> (&MuxWrapper.cast(&1, %LiveStream{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end
end
