defmodule MilkToAnalyse.App do
  use Commanded.Application, otp_app: :milk_to_analyse

  router MilkToAnalyse.Router

end
