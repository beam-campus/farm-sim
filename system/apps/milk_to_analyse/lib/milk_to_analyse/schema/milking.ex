defmodule MilkToAnalyse.Schema.Milking do
  use Ecto.Schema
  import Ecto.Changeset

  alias MilkToAnalyse.Schema.NippleStats

  @primary_key false
  embedded_schema do
    field :yield, :float
    field :bottle_number, :integer
    field :is_success, :boolean
    field :weight, :integer
    field :edi_status, :integer
    field :temperature, :float
    embeds_one :lf_stats, NippleStats
    embeds_one :lr_stats, NippleStats
    embeds_one :rf_stats, NippleStats
    embeds_one :rr_stats, NippleStats
  end

  def changeset(milking, args) do
    milking
    |> cast(args, [
      :yield,
      :bottle_number,
      :is_success,
      :weight,
      :edi_status,
      :temperature
    ])
    |> validate_required([
      :yield,
      :bottle_number,
      :is_success,
      :weight,
      :edi_status,
      :temperature
    ])
    |> cast_embed(:lf_stats, with: &NippleStats.changeset/2)
    |> cast_embed(:lr_stats, with: &NippleStats.changeset/2)
    |> cast_embed(:rf_stats, with: &NippleStats.changeset/2)
    |> cast_embed(:rr_stats, with: &NippleStats.changeset/2)
  end
end
