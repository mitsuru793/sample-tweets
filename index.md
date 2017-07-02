---
layout: home
---

{% for sample in site.data.tweet_sample %}
<h3>{{ sample.category }}</h3>
<ul>
  {% for tweet in sample.tweets %}
  <li>
    <h4>{{ tweet.title }}</h4>
    {{ site.data.tweet_html_set[tweet.url] }}
  </li>
  {% endfor %}
</ul>
{% endfor %}
