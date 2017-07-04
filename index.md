---
layout: home
---

JSONをクリックすると、ツイートオブジェクトが展開されます。

{% for sample in site.data.tweet_sample %}
  <h3>{{ sample.category }}</h3>
  <ul>
    {% for tweet in sample.tweets %}
      <li>
        <div>
          <h4>{{ tweet.title }}</h4>
          {{ site.data.tweet_embeds[tweet.url] }}
          <div class="json">
            <p class="toggle">JSON</p>
            <div class="hidden">
              {%- highlight json -%}
                {{ site.data.tweet_objects[tweet.url] }}
              {% endhighlight %}
            </div>
          </div>
        </div>
      </li>
    {% endfor %}
  </ul>
{% endfor %}
