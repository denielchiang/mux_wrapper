defmodule MuxWrapper.Assets do
  @moduledoc """
  Provides a wrapper of assets to manipulate Mux API
  """
  require Logger

  alias MuxWrapper.EmbeddedSchema.{Asset, AssetInfo}

  @doc """
  Provide create asset to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/create-asset) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - params - Map with 2 key `input` and `playback_policy`


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

      iex> MuxWrapper.Assets.create_asset(client, %{input: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"})
      %MuxWrapper.EmbeddedSchema.Asset{
        created_at: ~N[2021-03-19 13:13:26],
        id: "gbxJ8PYkJg9TOPhP0100gYIlZKqgCai4mBnummQu8YKUI",
        master_access: "none",
        mp4_support: "none",
        playback_ids: [],
        status: "preparing"
      }

  """
  @spec create_asset(%Tesla.Client{}, Enum.t()) :: %MuxWrapper.EmbeddedSchema.Asset{}
  def create_asset(client, params) do
    with {:ok, asset, _env} <- Mux.Video.Assets.create(client, params) do
      asset
      |> (&MuxWrapper.cast(&1, %Asset{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide delete asset from Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/delete-asset) first


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

      iex> MuxWrapper.Assets.delete_asset(client, "asset_id_very_long")
      :ok


  """
  @spec delete_asset(%Tesla.Client{}, String.t()) :: atom()
  def delete_asset(client, asset_id) do
    with {:ok, "", _env} <- Mux.Video.Assets.delete(client, asset_id) do
      :ok
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide get asset from Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/get-asset) first


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

      iex> MuxWrapper.Assets.get_asset(client, "asset_id_very_long")
      %MuxWrapper.EmbeddedSchema.Asset{
        aspect_ratio: nil,
        created_at: ~N[2021-03-19 14:09:04],
        duration: nil,
        id: "Aq02lD2TppLOibpXfrf5iHkwhTSuL666mYu02rfq7tHiA",
        master_access: "none",
        max_stored_frame_rate: nil,
        max_stored_resolution: nil,
        mp4_support: "none",
        playback_ids: [],
        status: "ready",
        test: nil,
        tracks: [
          %MuxWrapper.EmbeddedSchema.Track{
            duration: 60.095011,
            id: "01I6Bo00WSBCcLhEM01FYV01NeBhcs00w7SdZytiddeYdP01E",
            max_channel_layout: "stereo",
            max_channels: 2,
            max_frame_rate: nil,
            max_height: nil,
            max_width: nil,
            type: "audio"
          },
          %MuxWrapper.EmbeddedSchema.Track{
            duration: 60.095,
            id: "9BnaSlTgXT01nzpPnevBzuFP8i64bcoBUcnz3pdSMG44",
            max_channel_layout: nil,
            max_channels: nil,
            max_frame_rate: 23.962,
            max_height: 360,
            max_width: 640,
            type: "video"
          }
        ]
      }

  """
  @spec get_asset(%Tesla.Client{}, String.t()) :: %MuxWrapper.EmbeddedSchema.Asset{}
  def get_asset(client, asset_id) do
    with {:ok, asset, _env} <- Mux.Video.Assets.get(client, asset_id) do
      asset
      |> (&MuxWrapper.cast(&1, %Asset{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end

  @doc """
  Provide get asset info from Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/get-asset-input-info) first


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

      iex(4)> MuxWrapper.Assets.get_asset_input_info(client, "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k")
        [
          %MuxWrapper.EmbeddedSchema.AssetInfo{
            file: %MuxWrapper.EmbeddedSchema.File{
              container_format: "mov,mp4,m4a,3gp,3g2,mj2",
              tracks: [
                %MuxWrapper.EmbeddedSchema.Track{
                  channels: 2,
                  duration: 60.095011,
                  encoding: "aac",
                  frame_rate: nil,
                  height: nil,
                  id: nil,
                  max_channel_layout: nil,
                  max_channels: nil,
                  max_frame_rate: nil,
                  max_height: nil,
                  max_width: nil,
                  sample_rate: 22050,
                  type: "audio",
                  width: nil
                },
                %MuxWrapper.EmbeddedSchema.Track{
                  channels: nil,
                  duration: 60.095,
                  encoding: "h264",
                  frame_rate: 23.962,
                  height: 360,
                  id: nil,
                  max_channel_layout: nil,
                  max_channels: nil,
                  max_frame_rate: nil,
                  max_height: nil,
                  max_width: nil,
                  sample_rate: nil,
                  type: "video",
                  width: 640
                }
              ]
            },
            settings: %MuxWrapper.EmbeddedSchema.Settings{
              overlay_settings: nil,
              url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
            }
          },
          %MuxWrapper.EmbeddedSchema.AssetInfo{
            file: %MuxWrapper.EmbeddedSchema.File{
              container_format: "png",
              tracks: [
                %MuxWrapper.EmbeddedSchema.Track{
                  channels: nil,
                  duration: nil,
                  encoding: "png",
                  frame_rate: nil,
                  height: 346,
                  id: nil,
                  max_channel_layout: nil,
                  max_channels: nil,
                  max_frame_rate: nil,
                  max_height: nil,
                  max_width: nil,
                  sample_rate: nil,
                  type: "image",
                  width: 642
                }
              ]
            },
            settings: %MuxWrapper.EmbeddedSchema.Settings{
              overlay_settings: %MuxWrapper.EmbeddedSchema.OverlaySettings{
                horizontal_align: "center",
                opacity: "100.000000%",
                vertical_align: "bottom",
                vertical_margin: "100px",
                width: "640px"
              },
              url: "https://storage.googleapis.com/muxdemofiles/mux-test-video-watermark.png"
            }
          }
        ] 
  """
  @spec get_asset_input_info(%Tesla.Client{}, String.t()) :: Enum.t()
  def get_asset_input_info(client, asset_id) do
    with {:ok, input_info, _env} <- Mux.Video.Assets.input_info(client, asset_id) do
      input_info
      |> (&MuxWrapper.cast(&1, %AssetInfo{})).()
    else
      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end
end
