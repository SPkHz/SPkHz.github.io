---
layout: about
title: About
permalink: /
subtitle: Electrical Engineer
tagline: "RF • Millimeter-Wave Circuit Design • Millimeter-Wave Test & Measurement
  <br/> Analog Circuit Design • Artificial Neural Network Applications
  <br/> Digital Signal Processing • Embedded Real-Time Kernels
  <br/> Discrete Digital Control Systems • Analog Control Systems"

profile:
  align: right
  image: prof_pic.jpg
  image_circular: true # crops the image to make it circular
  more_info: >
    <p><strong>Connect</strong></p>
    <br/>
    <p><i class="fa-brands fa-linkedin"></i> <a href="https://www.linkedin.com/in/PLACE-LINKEDIN-HERE/">LinkedIn</a></p>
    <br/>
    <p><i class="fa-brands fa-github"></i> <a href="https://github.com/SPkHz">GitHub</a></p>
    <br/>
    <p><i class="fa-solid fa-envelope"></i> <a href="mailto:Steven.Placzek@ieee.org">Email</a></p>

selected_papers: false # includes a list of papers marked as "selected={true}"
social: false # includes social icons at the bottom of the page

announcements:
  enabled: true # includes a list of news items
  scrollable: false # adds a vertical scroll bar if there are more than 3 news items
  limit: 25 # leave blank to include all the news in the `_news` folder

latest_posts:
  enabled: true
  scrollable: true # adds a vertical scroll bar if there are more than 3 new posts items
  limit: 5 # leave blank to include all the blog posts
---

I am an Electrical Engineering student (graduating May 16th, 2026) specializing in RF/microwave circuit design, digital signal processing, and embedded systems. Experienced with industry-standard tools (Keysight ADS, LTspice, MATLAB/Simulink) and delivering comprehensive technical documentation with reproducible results.

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
  padding: 0.15rem 0.5rem;
  border: 1px solid rgba(0, 0, 0, 0.12);
  border-radius: 999px;
  font-size: 0.8rem;
  margin: 0 0.25rem 0.25rem 0;
  color: rgba(0, 0, 0, 0.75);
  background: rgba(0, 0, 0, 0.02);
}

html[data-theme="dark"] .tag {
  border-color: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.78);
  background: rgba(255, 255, 255, 0.06);
}
</style>

{% assign featured = site.data.projects | where: "featured", true %}
{% if featured.size == 0 %}
{% assign featured = site.data.projects | slice: 0, 3 %}
{% endif %}

<div class="row">
{% for p in featured %}
  <div class="col-12 col-md-6 mb-3">
    <div class="card h-100">
      {% if p.img and p.img != "" %}
      <img src="{{ p.img | relative_url }}" class="card-img-top" alt="{{ p.title }}" style="aspect-ratio: 16/9; object-fit: cover;">
      {% endif %}
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
