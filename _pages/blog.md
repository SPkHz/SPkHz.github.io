---
layout: default
permalink: /articles/
title: Articles
nav: true
nav_order: 1
pagination:
  enabled: true
  collection: posts
  permalink: /page/:num/
  per_page: 50
  sort_field: date
  sort_reverse: true
  trail:
    before: 3 # The number of links before the current page
    after: 3 # The number of links after the current page
---

<div class="post">

{% assign blog_name_size = site.blog_name | size %}
{% assign blog_description_size = site.blog_description | size %}

{% if blog_name_size > 0 or blog_description_size > 0 %}

  <div class="header-bar">
    <h1>{{ site.blog_name }}</h1>
    <h2>{{ site.blog_description }}</h2>
  </div>
  {% endif %}

{% if site.display_tags and site.display_tags.size > 0 or site.display_categories and site.display_categories.size > 0 %}

  <div class="tag-category-list">
    <ul class="p-0 m-0">
      {% for tag in site.display_tags %}
        <li>
          <i class="fa-solid fa-hashtag fa-sm"></i> <a href="{{ tag | slugify | prepend: '/blog/tag/' | relative_url }}">{{ tag }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
      {% endfor %}
      {% if site.display_categories.size > 0 and site.display_tags.size > 0 %}
        <p>&bull;</p>
      {% endif %}
      {% for category in site.display_categories %}
        <li>
          <i class="fa-solid fa-tag fa-sm"></i> <a href="{{ category | slugify | prepend: '/blog/category/' | relative_url }}">{{ category }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
      {% endfor %}
    </ul>
  </div>
  {% endif %}

{% assign featured_posts = site.posts | where: "featured", "true" %}
{% if featured_posts.size > 0 %}

<div class="featured-section">
  <h2 class="featured-section-title">
    <i class="fa-solid fa-star fa-sm"></i> Featured Projects
  </h2>
  <div class="featured-posts-grid">
    {% for post in featured_posts %}
    <a href="{{ post.url | relative_url }}" class="featured-card hoverable">
      {% if post.thumbnail %}
      <div class="featured-card-thumbnail">
        <img src="{{ post.thumbnail | relative_url }}" alt="{{ post.title }}" loading="lazy">
      </div>
      {% endif %}
      <div class="featured-card-content">
        <div class="featured-card-badge">
          <i class="fa-solid fa-thumbtack fa-xs"></i> Featured
        </div>
        <h3 class="featured-card-title">{{ post.title }}</h3>
        <p class="featured-card-description">{{ post.description }}</p>
        {% if post.external_source == blank %}
          {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
        {% else %}
          {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
        {% endif %}
        {% assign year = post.date | date: "%Y" %}
        <p class="featured-card-meta">
          <span>{{ read_time }} min read</span>
          <span class="meta-separator">&middot;</span>
          <span>{{ year }}</span>
        </p>
      </div>
    </a>
    {% endfor %}
  </div>
</div>
<hr>

{% endif %}

  <div class="post-card-list">

    {% if page.pagination.enabled %}
      {% assign postlist = paginator.posts %}
    {% else %}
      {% assign postlist = site.posts %}
    {% endif %}

    {% for post in postlist %}

    {% if post.external_source == blank %}
      {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
    {% else %}
      {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
    {% endif %}
    {% assign year = post.date | date: "%Y" %}
    {% assign tags = post.tags | join: "" %}
    {% assign categories = post.categories | join: "" %}

    <article class="post-card hoverable">
      {% if post.redirect == blank %}
        {% assign post_url = post.url | relative_url %}
      {% elsif post.redirect contains '://' %}
        {% assign post_url = post.redirect %}
      {% else %}
        {% assign post_url = post.redirect | relative_url %}
      {% endif %}

      <a href="{{ post_url }}" class="post-card-link" {% if post.redirect contains '://' %}target="_blank" rel="noopener"{% endif %}>
        <div class="post-card-inner">
          {% if post.thumbnail %}
          <div class="post-card-thumbnail">
            <img src="{{ post.thumbnail | relative_url }}" alt="{{ post.title }}" loading="lazy">
          </div>
          {% endif %}
          <div class="post-card-content">
            <h3 class="post-card-title">
              {{ post.title }}
              {% if post.redirect contains '://' %}
              <svg width="1rem" height="1rem" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg" class="external-link-icon">
                <path d="M17 13.5v6H5v-12h6m3-3h6v6m0-6-9 9" class="icon_svg-stroke" stroke="currentColor" stroke-width="2" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path>
              </svg>
              {% endif %}
            </h3>
            <p class="post-card-description">{{ post.description }}</p>
            <p class="post-card-meta">
              <span class="meta-date">{{ post.date | date: '%b %d, %Y' }}</span>
              <span class="meta-separator">&middot;</span>
              <span class="meta-read-time">{{ read_time }} min read</span>
              {% if post.external_source %}
              <span class="meta-separator">&middot;</span>
              <span class="meta-source">{{ post.external_source }}</span>
              {% endif %}
            </p>
          </div>
        </div>
      </a>

      <div class="post-card-tags">
        {% assign all_tags = post.tags | concat: post.categories %}
        {% assign tag_count = all_tags | size %}
        {% assign visible_limit = 3 %}

        {% for tag in post.tags limit: visible_limit %}
        <a href="{{ tag | slugify | prepend: '/blog/tag/' | relative_url }}" class="tag-chip">
          <i class="fa-solid fa-hashtag fa-xs"></i>{{ tag }}
        </a>
        {% endfor %}

        {% for category in post.categories limit: visible_limit %}
        {% assign tags_shown = post.tags | size %}
        {% if tags_shown < visible_limit %}
        <a href="{{ category | slugify | prepend: '/blog/category/' | relative_url }}" class="tag-chip category-chip">
          <i class="fa-solid fa-tag fa-xs"></i>{{ category }}
        </a>
        {% endif %}
        {% endfor %}

        {% if tag_count > visible_limit %}
        <button class="tag-chip tag-more-btn" onclick="this.parentElement.classList.toggle('show-all-tags'); this.textContent = this.parentElement.classList.contains('show-all-tags') ? 'Less' : '+{{ tag_count | minus: visible_limit }} more'; event.preventDefault();">
          +{{ tag_count | minus: visible_limit }} more
        </button>

        <span class="tags-expanded">
          {% for tag in post.tags offset: visible_limit %}
          <a href="{{ tag | slugify | prepend: '/blog/tag/' | relative_url }}" class="tag-chip">
            <i class="fa-solid fa-hashtag fa-xs"></i>{{ tag }}
          </a>
          {% endfor %}

          {% assign remaining_cat_slots = visible_limit | minus: post.tags.size %}
          {% if remaining_cat_slots < 0 %}{% assign remaining_cat_slots = 0 %}{% endif %}
          {% for category in post.categories offset: remaining_cat_slots %}
          <a href="{{ category | slugify | prepend: '/blog/category/' | relative_url }}" class="tag-chip category-chip">
            <i class="fa-solid fa-tag fa-xs"></i>{{ category }}
          </a>
          {% endfor %}
        </span>
        {% endif %}

        <a href="{{ year | prepend: '/blog/' | relative_url }}" class="tag-chip year-chip">
          <i class="fa-solid fa-calendar fa-xs"></i>{{ year }}
        </a>
      </div>
    </article>

    {% endfor %}

  </div>

{% if page.pagination.enabled %}
{% include pagination.liquid %}
{% endif %}

</div>
