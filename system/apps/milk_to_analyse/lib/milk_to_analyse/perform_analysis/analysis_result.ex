defmodule MilkToAnalyse.PerformAnalysis.AnalysisResult do
  use Ecto.Schema

  embedded_schema do
    field :pct_fat, :float
    field :antibiotics, :boolean
  end



end
