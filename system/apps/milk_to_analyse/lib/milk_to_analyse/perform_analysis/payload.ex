defmodule MilkToAnalyse.PerformAnalysis.Payload do
  alias MilkToAnalyse.PerformAnalysis.AnalysisResult
  alias Schema.Milking
  use Ecto.Schema

  embedded_schema do
    field :life_id, :string
    field :robot_id, :string
    embeds_one :milking, Milking
    embeds_one :result, AnalysisResult
  end




end
