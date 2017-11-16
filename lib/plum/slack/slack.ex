defmodule Plum.Slack do
  def prospect_message(message) do
    Application.get_env(:plum, :env) == "prod" &&
      HTTPoison.post "https://hooks.slack.com/services/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", Poison.encode! %{"text" => message}
  end
end
