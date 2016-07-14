defmodule FemiEducation.PageController do
  use FemiEducation.Web, :controller

  def index(conn, _params) do
    topics = FemiEducation.get_dirs()
    articles = FemiEducation.get_articles()
    render conn, "index.html"
  end

  def check_topic(conn, params, func) do
    all_articles = FemiEducation.get_articles()
    articles = all_articles[params["topic"]]
    case articles do
      nil ->
        render conn, params["no-topic"]
      _ ->
        func.(articles)
    end
  end

  def topic(conn, params) do
    topic = params["topic"]
    info_file = FemiEducation.get_info()
    check_topic(conn, %{"topic" => topic, "no-topic" => "no-topic.html"}, fn(articles) ->
      links = Map.keys(articles)
        |> List.delete(info_file)
        |> Enum.map(fn(article) ->
          articles[article]
        end)

      rendered_topic = articles[info_file]
        |> Enum.into(%{"__link" => topic})

      render conn, "topic.html", links: links, topic: rendered_topic, meta: rendered_topic, rendered_topic: topic
    end)
  end

  def article(conn, params) do
    topic = params["topic"]
    article_id = params["article"]
    check_topic(conn, %{"topic" => topic, "no-topic" => "no-topic.html"}, fn(articles) ->
      keys = Map.keys(articles)
      raw_article = articles[article_id]

      case raw_article do
        nil ->
          render conn, "no-topic.html"
        _ ->
          article = raw_article
          render conn, "article.html", article: article["body"], topic: topic, rendered_topic: topic
      end
    end)
  end
end
