defmodule MilkToAnalyse.Router do
  use Commanded.Commands.Router

  identify(MilkToAnalyse.Aggregate,
    by: :agg_id
  )

  dispatch(MilkToAnalyse.Initialize.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.CaptureLife.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.CollectMilk.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.PerformAnalysis.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.PrepareRobot.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.ReleaseLife.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )

  dispatch(MilkToAnalyse.SanitizeLife.Cmd,
    to: MilkToAnalyse.Aggregate,
    identity: :agg_id
  )
end
