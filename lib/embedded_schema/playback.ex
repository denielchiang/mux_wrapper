defmodule MuxWrapper.EmbeddedSchema.Playback do
  @moduledoc "%Playback{} struct which defines receiver's live stream for API Client"

  use Ecto.Schema

  import Ecto.Changeset

  @policy_options %{
    public: :public,
    signed: :signed
  }

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:policy, :string)
  end

  @all_fields ~w(id policy)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
  end

  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> apply_changes
  end

  def policy_public, do: @policy_options.public
  def policy_private, do: @policy_options.signed
end
