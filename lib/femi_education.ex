defmodule FemiEducation do
  use Application

  @info_file "__info.md"
  @markdown_values ["title", "subtitle"]
  @prefix "web/static/articles"
  @dirs File.ls!(@prefix)
  @articles Enum.reduce(@dirs, %{}, fn
      (topic, acc) ->
        articles = File.ls!("#{@prefix}/#{topic}")
        articles_data = Enum.reduce(articles, %{}, fn
          (article, acc) ->
            content = File.read!("#{@prefix}/#{topic}/#{article}")
            article_without_extension = if String.ends_with?(article, ".md") && article != @info_file do
              String.slice(article, 0..-4)
            else
              article
            end
            parsed_content = String.split(content, "\n\n", parts: 2)
            parsed_content_length = length parsed_content
            sanitized_content = if parsed_content_length == 1 do
              parsed_content ++ [""]
            else
              parsed_content
            end
            [meta, body] = sanitized_content
            meta_dict = String.split(meta, "\n")
              |> Enum.map(fn(x) -> String.strip(x) end)
              |> Enum.filter(fn(line) -> String.length(line) != 0 end)
              |> Enum.reduce(%{}, fn
                (line, acc) ->
                  [name, value] = String.split(line, ":", parts: 2)
                  processed_value = if Enum.member?(@markdown_values, name) do
                    Earmark.to_html(value)
                  else
                    value
                  end
                  Enum.into(acc, %{name => processed_value})
              end)

            link = if article == @info_file do
              "/#{topic}"
            else
              "/#{topic}/#{article_without_extension}"
            end

            article_dict = Enum.into(meta_dict, %{
              "id" => article_without_extension,
              "topic" => topic,
              "body" => Earmark.to_html(body),
              "link" => link
            })

            Enum.into(acc, %{article_without_extension => article_dict})
          end)
        Enum.into(acc, %{topic => articles_data})
    end)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(FemiEducation.Endpoint, []),
      # Start the Ecto repository
      supervisor(FemiEducation.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(FemiEducation.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FemiEducation.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FemiEducation.Endpoint.config_change(changed, removed)
    :ok
  end

  def get_dirs do
    @dirs
  end

  def get_articles do
    @articles
  end

  def get_info do
    @info_file
  end
end
