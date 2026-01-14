---
layout: about
title: about
permalink: /
subtitle: "RF / DSP / EE — analog circuits, SDR signal processing, and measurement-driven design."

profile:
  align: right
  image: prof_pic.jpg
  image_circular: false # crops the image to make it circular
  more_info: >
    <p><a href="https://github.com/SPkHz">github.com/SPkHz</a></p>
    <p><a href="https://www.linkedin.com/in/PLACE-LINKEDIN-HERE/">LinkedIn</a></p>

selected_papers: false # includes a list of papers marked as "selected={true}"
social: false # includes social icons at the bottom of the page

announcements:
  enabled: true # includes a list of news items
  scrollable: true # adds a vertical scroll bar if there are more than 3 news items
  limit: 5 # leave blank to include all the news in the `_news` folder

latest_posts:
  enabled: true
  scrollable: true # adds a vertical scroll bar if there are more than 3 new posts items
  limit: 3 # leave blank to include all the blog posts
---

I build and document engineering projects end-to-end: design intent, simulation, measurements, and the writeup (usually LaTeX + a compiled PDF).

<div class="d-flex flex-wrap" style="gap: .5rem; margin: 1rem 0 1.25rem 0;">
  <a class="btn btn-primary btn-sm" href="{{ '/projects/' | relative_url }}">Projects</a>
  <a class="btn btn-outline-secondary btn-sm" href="https://github.com/SPkHz">GitHub</a>
  <a class="btn btn-outline-secondary btn-sm" href="https://www.linkedin.com/in/YOUR-LINKEDIN-HERE/">LinkedIn</a>
  <a class="btn btn-outline-secondary btn-sm" href="{{ '/assets/pdf/Steven_Placzek_Resume.pdf' | relative_url }}">Resume PDF</a>
</div>

## Featured projects

<style>
.tag {
  display: inline-block;
  padding: .15rem .5rem;
  border: 1px solid rgba(0,0,0,.12);
  border-radius: 999px;
  font-size: .8rem;
  margin: 0 .25rem .25rem 0;
  color: rgba(0,0,0,.75);
  background: rgba(0,0,0,.02);
}
</style>

{% assign featured = site.data.projects | where: "featured", true %}
{% if featured.size == 0 %}
  {% assign featured = site.data.projects | slice: 0, 3 %}
{% endif %}

<div class="row">
{% for p in featured %}
  <div class="col-12 col-md-6 col-lg-4 mb-3">
    <div class="card h-100">
      <div class="card-body">
        <h5 class="card-title">{{ p.title }}</h5>
        {% if p.summary and p.summary != "" %}
        <p class="card-text">{{ p.summary }}</p>
        {% endif %}

        {% if p.tags and p.tags.size > 0 %}
        <div style="margin: .25rem 0 .75rem 0;">
          {% for t in p.tags %}
            <span class="tag">{{ t }}</span>
          {% endfor %}
        </div>
        {% endif %}

        <div class="d-flex flex-wrap" style="gap: .5rem;">
          {% if p.view and p.view != "" %}<a class="btn btn-sm btn-primary" href="{{ p.view }}">View</a>{% endif %}
          {% if p.source and p.source != "" %}<a class="btn btn-sm btn-outline-secondary" href="{{ p.source }}">Source</a>{% endif %}
          {% if p.pdf and p.pdf != "" %}<a class="btn btn-sm btn-outline-secondary" href="{{ p.pdf }}">PDF</a>{% endif %}
        </div>
      </div>
    </div>
  </div>
{% endfor %}
</div>

<p style="margin-top:.75rem;">
  Full list: <a href="{{ '/projects/' | relative_url }}">Projects</a>
</p>