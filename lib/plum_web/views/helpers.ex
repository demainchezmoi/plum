defmodule PlumWeb.PlumViewHelpers do
  use Phoenix.HTML
  @img_path_base "https://dx6bud56fsm7y.cloudfront.net/maison_leo/images"

  @resolutions [
    {"400x225", 400},
    {"800x450", 800},
    {"1200x675", 1200},
    {"1920x1080", 1920}
  ]

  def img_path(name, :default, format), do: "#{@img_path_base}/#{name}-800X450.#{format}"
  def img_path(name, res, format), do: "#{@img_path_base}/#{name}-#{res}.#{format}"

  def srcset(name, format) do
    @resolutions
    |> Enum.map(fn {res, width} -> "#{img_path(name, res, format)} #{width}w" end)
    |> Enum.join(", ")
  end

  def src_tags(name, options \\ []) do
    lazystring = if options |> Keyword.get(:lazy), do: "data-", else: ""
    format = Keyword.get(options, :format) || "png"
    raw "#{lazystring}srcset=\"#{srcset(name, format)}\" #{lazystring}src=\"#{img_path(name, :default, "png")}\""
  end
end
