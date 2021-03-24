defmodule MuxWrapper.Assets do
  @moduledoc """
  Provides a wrapper of assets to manipulate Mux API
  """
  alias Mux.Video.Assets
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
      {:ok, 
        %MuxWrapper.EmbeddedSchema.Asset{
          created_at: ~N[2021-03-19 13:13:26],
          id: "gbxJ8PYkJg9TOPhP0100gYIlZKqgCai4mBnummQu8YKUI",
          master_access: "none",
          mp4_support: "none",
          playback_ids: [],
          status: "preparing"
        }
      }


  """
  @spec create_asset(%Tesla.Client{}, Enum.t()) :: tuple()
  def create_asset(client, params) do
    case Assets.create(client, params) do
      {:ok, asset, _env} ->
        asset
        |> (&MuxWrapper.cast(&1, %Asset{})).()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok}


  """
  @spec delete_asset(%Tesla.Client{}, String.t()) :: tuple()
  def delete_asset(client, asset_id) do
    case Assets.delete(client, asset_id) do
      {:ok, "", _env} ->
        MuxWrapper.success()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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
      {:ok, 
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
      }


  """
  @spec get_asset(%Tesla.Client{}, String.t()) :: tuple()
  def get_asset(client, asset_id) do
    case Assets.get(client, asset_id) do
      {:ok, asset, _env} ->
        asset
        |> (&MuxWrapper.cast(&1, %Asset{})).()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
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

      iex> MuxWrapper.Assets.get_asset_input_info(client, "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k")
      {:ok,
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
      }
       

  """
  @spec get_asset_input_info(%Tesla.Client{}, String.t()) :: tuple()
  def get_asset_input_info(client, asset_id) do
    case Assets.input_info(client, asset_id) do
      {:ok, input_info, _env} ->
        input_info
        |> (&MuxWrapper.cast(&1, %AssetInfo{})).()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide list assets from Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/list-assets) first


  ## Parameters

  - client - provid by `MuxWrapper.client/0`
  - opt: pagnation query params, can pass a Map like this `%{limit: 10, page: 3}`. If don't pass, the default value from Mux is limit: 25 and page: 1


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

      iex> MuxWrapper.Assets.list_assets(client, %{limit: 1, page: 1})
      {:ok,
        [
          %MuxWrapper.EmbeddedSchema.Asset{
            aspect_ratio: "16:9",
            created_at: ~N[2021-03-19 14:37:50],
            duration: 10,
            id: "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k",
            master_access: "none",
            max_stored_frame_rate: 23.962,
            max_stored_resolution: "SD",
            mp4_support: "none",
            playback_ids: [],
            status: "ready",
            test: true,
            tracks: [
              %MuxWrapper.EmbeddedSchema.Track{
                channels: nil,
                duration: 60.095011,
                encoding: nil,
                frame_rate: nil,
                height: nil,
                id: "J00OusXFvcz9UJo93Vd5bFs1EsXX9cd1HqLs6lPWrRSA",
                max_channel_layout: "stereo",
                max_channels: 2,
                max_frame_rate: nil,
                max_height: nil,
                max_width: nil,
                sample_rate: nil,
                type: "audio",
                width: nil
              },
              %MuxWrapper.EmbeddedSchema.Track{
                channels: nil,
                duration: 60.095,
                encoding: nil,
                frame_rate: nil,
                height: nil,
                id: "2xI4b59vNk02DZ01EmtGk2bOYSb1vY4lmtmb6luBW500Tw",
                max_channel_layout: nil,
                max_channels: nil,
                max_frame_rate: 23.962,
                max_height: 360,
                max_width: 640,
                sample_rate: nil,
                type: "video",
                width: nil
              }
            ]
          }
        ]  
      }

  """
  @spec list_assets(%Tesla.Client{}, Enum.t()) :: tuple()
  def list_assets(client, opt \\ %{}) do
    case Assets.list(client, opt) do
      {:ok, assets, _env} ->
        assets
        |> (&MuxWrapper.cast(&1, %Asset{})).()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @doc """
  Provide a high qulity link to download from Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/update-asset-master-access) first


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

      iex> MuxWrapper.Assets.update_master_access(client, "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A")
      {:ok,
        %MuxWrapper.EmbeddedSchema.Asset{
          aspect_ratio: "16:9",
          created_at: ~N[2021-03-20 12:43:16],
          duration: 10,
          id: "CO2pRYhPHeLzmv5MnmuRLmUSEYy4TvHj6gKcoU2kM7A",
          master_access: "temporary",
          max_stored_frame_rate: 23.962,
          max_stored_resolution: "SD",
          mp4_support: "none",
          playback_ids: [],
          status: "ready",
          test: true,
          tracks: [
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095011,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "kRW00Gn2NfljlA5KBPo01gTf7mijCWvVN801Nh02NTRbTZY",
              max_channel_layout: "stereo",
              max_channels: 2,
              max_frame_rate: nil,
              max_height: nil,
              max_width: nil,
              sample_rate: nil,
              type: "audio",
              width: nil
            },
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "Wo6cajmOIRCygGv85fTTVXX29GYSlhUyQVUJA4h41mU",
              max_channel_layout: nil,
              max_channels: nil,
              max_frame_rate: 23.962,
              max_height: 360,
              max_width: 640,
              sample_rate: nil,
              type: "video",
              width: nil
            }
          ]
        }
      }


  """
  @master_access %{
    master_access: "temporary"
  }
  @spec update_master_access(%Tesla.Client{}, String.t()) :: tuple()
  def update_master_access(client, asset_id) do
    case Assets.update_master_access(client, asset_id, @master_access) do
      {:ok, asset, _env} ->
        asset
        |> (&MuxWrapper.cast(&1, %Asset{})).()

      {:error, reason, details} ->
        reason
        |> MuxWrapper.print_errors(details)
    end
  end

  @mp4 %{
    support: "standard",
    unsupport: "none"
  }
  @doc """
  Provide mp4 support(added) to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/update-asset-mp4-support) first


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

      iex> MuxWrapper.Assets.set_mp4_support(client, "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k")
      {:ok,
        %MuxWrapper.EmbeddedSchema.Asset{
          aspect_ratio: "16:9",
          created_at: ~N[2021-03-19 14:37:50],
          duration: 10,
          id: "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k",
          master_access: "temporary",
          max_stored_frame_rate: 23.962,
          max_stored_resolution: "SD",
          mp4_support: "standard",
          playback_ids: [],
          status: "ready",
          test: true,
          tracks: [
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095011,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "J00OusXFvcz9UJo93Vd5bFs1EsXX9cd1HqLs6lPWrRSA",
              max_channel_layout: "stereo",
              max_channels: 2,
              max_frame_rate: nil,
              max_height: nil,
              max_width: nil,
              sample_rate: nil,
              type: "audio",
              width: nil
            },
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "2xI4b59vNk02DZ01EmtGk2bOYSb1vY4lmtmb6luBW500Tw",
              max_channel_layout: nil,
              max_channels: nil,
              max_frame_rate: 23.962,
              max_height: 360,
              max_width: 640,
              sample_rate: nil,
              type: "video",
              width: nil
            }
          ]
        } 
      }


  """
  @spec set_mp4_support(%Tesla.Client{}, String.t()) :: tuple()
  def set_mp4_support(client, asset_id),
    do: update_mp4_support(client, asset_id, %{mp4_support: @mp4.support})

  @doc """
  Provide mp4 not support(removed video) to Mux, suggest read [Mux doc](https://docs.mux.com/api-reference/video#operation/update-asset-mp4-support) first


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

      iex> MuxWrapper.Assets.set_mp4_unsupport(client, "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k")
      {:ok,
        %MuxWrapper.EmbeddedSchema.Asset{
          aspect_ratio: "16:9",
          created_at: ~N[2021-03-19 14:37:50],
          duration: 10,
          id: "doS01p7VusXkwqfhe18LDttqIXV4xqXvd53K8ORee501k",
          master_access: "temporary",
          max_stored_frame_rate: 23.962,
          max_stored_resolution: "SD",
          mp4_support: "none",
          playback_ids: [],
          status: "ready",
          test: true,
          tracks: [
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095011,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "J00OusXFvcz9UJo93Vd5bFs1EsXX9cd1HqLs6lPWrRSA",
              max_channel_layout: "stereo",
              max_channels: 2,
              max_frame_rate: nil,
              max_height: nil,
              max_width: nil,
              sample_rate: nil,
              type: "audio",
              width: nil
            },
            %MuxWrapper.EmbeddedSchema.Track{
              channels: nil,
              duration: 60.095,
              encoding: nil,
              frame_rate: nil,
              height: nil,
              id: "2xI4b59vNk02DZ01EmtGk2bOYSb1vY4lmtmb6luBW500Tw",
              max_channel_layout: nil,
              max_channels: nil,
              max_frame_rate: 23.962,
              max_height: 360,
              max_width: 640,
              sample_rate: nil,
              type: "video",
              width: nil
            }
          ]
        } 
      }


  """
  @spec set_mp4_unsupport(%Tesla.Client{}, String.t()) :: tuple()
  def set_mp4_unsupport(client, asset_id),
    do: update_mp4_support(client, asset_id, %{mp4_support: @mp4.unsupport})

  defp update_mp4_support(client, asset_id, params) do
    case Assets.update_mp4_support(client, asset_id, params) do
      {:ok, asset, _env} ->
        asset
        |> (&MuxWrapper.cast(&1, %Asset{})).()

      {:error, reason, details} ->
        MuxWrapper.print_errors(reason, details)

        :error
    end
  end
end
