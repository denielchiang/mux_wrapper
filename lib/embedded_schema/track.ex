defmodule MuxWrapper.EmbeddedSchema.Track do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:duration, :float)
    field(:max_channel_layout, :string)
    field(:max_channels, :integer)
    field(:type, :string)
    field(:max_frame_rate, :float)
    field(:max_height, :integer)
    field(:max_width, :integer)
    field(:channels, :integer)
    field(:encoding, :string)
    field(:sample_rate, :integer)
    field(:frame_rate, :float)
    field(:height, :integer)
    field(:width, :integer)
  end

  @doc false
  @all_fields ~w(
    id duration max_channels max_channel_layout type
    max_frame_rate max_height max_width channels encoding
    sample_rate frame_rate height width)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
  end

  @doc false
  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
  end
end
