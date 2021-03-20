defmodule MuxWrapper.EmbeddedSchema.Settings do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.OverlaySettings

  @primary_key false
  embedded_schema do
    field(:url, :string)
    embeds_one(:overlay_settings, OverlaySettings, on_replace: :delete)
  end

  @doc false
  @all_fields ~w(url)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:overlay_settings, with: &OverlaySettings.changeset/2)
  end

  @doc false
  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:overlay_settings, with: &OverlaySettings.changeset/2)
    |> apply_changes
  end
end
