defmodule MuxWrapper.Playbacks do
  @moduledoc """
  Provides a wrapper of playback ids to manipulate Mux API
  """
  alias MuxWrapper.EmbeddedSchema.Playback

  @typedoc """
  A playback embedded schema, e.g. id, policy
  """
  @type playback :: MuxWrapper.EmbeddedSchema.Playback

  @privacy %{
    public: "public",
    private: "signed"
  }

  @doc """
  Create a `public` new playback ID by asset id. to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-asset-playback-id) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - asset_id - asset id

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

      iex> MuxWrapper.Playbacks.create_public_playback_id(client, "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A")
      %MuxWrapper.EmbeddedSchema.Playback{
        id: "UdNWaprxjIA01BUYYDJpaCiDZQu22Ep6tAJLOLA8Sk7A",
        policy: "public"
      }


  """
  @spec create_public_playback_id(%Tesla.Client{}, String.t()) :: playback
  def(create_public_playback_id(client, asset_id),
    do: create_playback_id(client, asset_id, %{policy: @privacy.public})
  )

  @doc """
  Create a `signed` new playback ID by asset id. to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-asset-playback-id) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - asset_id - asset id

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

      iex> MuxWrapper.Playbacks.create_private_playback_id(client, "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A")
      %MuxWrapper.EmbeddedSchema.Playback{
        id: "yP29YfRnmqr6Ft47nd9FscOTq5Eo63UWB74TJSeo9Es",
        policy: "signed"
      } 


  """
  @spec create_private_playback_id(%Tesla.Client{}, String.t()) :: playback
  def create_private_playback_id(client, asset_id),
    do: create_playback_id(client, asset_id, %{policy: @privacy.private})

  defp create_playback_id(client, asset_id, params) do
    with {:ok, playback_id, _env} <- Mux.Video.PlaybackIds.create(client, asset_id, params) do
      playback_id
      |> (&MuxWrapper.cast(&1, %Playback{})).()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Delete a playback by asset id and playback id. to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/delete-asset-playback-id) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - asset_id - asset id
  - playback_id - playback id

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

      iex> MuxWrapper.Playbacks.delete(client, "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A", "UdNWaprxjIA01BUYYDJpaCiDZQu22Ep6tAJLOLA8Sk7A")
      {:ok}
      
      iex> MuxWrapper.Playbacks.delete(client, "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A", "UdNWaprxjIA01BUYYDJpaCiDZQu22Ep6tAJLOLA8Sk7A")
      03:09:29.925 [error] Mux pass in msg: "not_found: Playback ID not found"
      {:error} 
  """
  @spec delete(%Tesla.Client{}, String.t(), String.t()) :: tuple()
  def delete(client, asset_id, playback_id) do
    with {:ok, "", _env} <- Mux.Video.PlaybackIds.delete(client, asset_id, playback_id) do
      MuxWrapper.success()
    else
      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end
end
