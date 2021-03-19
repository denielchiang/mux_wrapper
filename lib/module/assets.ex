defmodule MuxWrapper.Assets do
  @moduledoc """
  Provides a wrapper of assets to manipulate Mux API
  """
  require Logger

  alias MuxWrapper.EmbeddedSchema.Asset

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
end
