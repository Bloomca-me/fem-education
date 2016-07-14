defmodule FemiEducation.LayoutView do
  use FemiEducation.Web, :view

  def title do
    "Awesome New Title!"
  end

  def check_active(rendered_topic, topic) do
    rendered_topic == topic["topic"]
  end

  def get_menu do
    topics = FemiEducation.get_dirs()
    all_articles = FemiEducation.get_articles()
    info_file = FemiEducation.get_info()
    Enum.map(topics, fn(topic) ->
      all_articles[topic][info_file]
    end)
  end

  def render_meta(meta) do
    case meta do
      nil ->
        """
          <title>Матчасть феминизма</title>
          <meta name="keywords" content="феминизм, история феминизма, матчасть феминизма, термины феминизма, критика феминизма, объяснение феминизма" />
          <meta name="description" content="Объяснение базовых терминов и идей феминизма, его истории; положительное влияение и аргументированная критика" />
          <meta property="og:url" content="http://femi.education/">
          <meta property="og:title" content="Матчасть феминизма">
          <meta property="og:description" content="Объяснение базовых терминов и идей феминизма, его истории; положительное влияение и аргументированная критика">
        """
      _ ->
        """
          <title>#{meta["meta_title"]}</title>
          <meta name="keywords" content="#{meta["meta_keywords"]}" />
          <meta name="description" content="#{meta["meta_description"]}" />
          <meta property="og:url" content="http://femi.education#{meta["link"]}">
          <meta property="og:title" content="#{meta["meta_title"]}">
          <meta property="og:description" content="#{meta["meta_description"]}">
        """
    end
  end

  def render_metrics do
    case Mix.env do
      :dev ->
        ""
      _ ->
      """
        <script>
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

          ga('create', 'UA-80700110-1', 'auto');
          ga('send', 'pageview');

        </script>
        <!-- Yandex.Metrika counter -->
        <script type="text/javascript">
          (function (d, w, c) {
              (w[c] = w[c] || []).push(function() {
                  try {
                      w.yaCounter38465625 = new Ya.Metrika({
                          id:38465625,
                          clickmap:true,
                          trackLinks:true,
                          accurateTrackBounce:true
                      });
                  } catch(e) { }
              });

              var n = d.getElementsByTagName("script")[0],
                  s = d.createElement("script"),
                  f = function () { n.parentNode.insertBefore(s, n); };
              s.type = "text/javascript";
              s.async = true;
              s.src = "https://mc.yandex.ru/metrika/watch.js";

              if (w.opera == "[object Opera]") {
                  d.addEventListener("DOMContentLoaded", f, false);
              } else { f(); }
          })(document, window, "yandex_metrika_callbacks");
        </script>
        <noscript><div><img src="https://mc.yandex.ru/watch/38465625" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
        <!-- /Yandex.Metrika counter -->
      """
    end
  end
end
