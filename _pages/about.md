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
  image: kicad_main_board.png
  image_alt: KiCad PCB layout for an RF/microwave main board
  image_circular: true # crops the image to make it circular
  more_info: >
    <p><strong>Connect</strong></p>
    <br/>
    <p><i class="fa-brands fa-github"></i> <a href="https://github.com/SPkHz">GitHub</a></p>
    <br/>
    <p><i class="fa-solid fa-envelope"></i> <a href="mailto:Steven.Placzek@ieee.org">Email</a></p>

# LinkedIn placeholders stay unpublished until the résumé is polished and approved.
# Profile: https://www.linkedin.com/in/PLACE-LINKEDIN-HERE/
# Button: https://www.linkedin.com/in/YOUR-LINKEDIN-HERE/

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

<div class="d-flex flex-wrap about-actions">
  <a class="btn btn-primary btn-sm" href="{{ '/projects/' | relative_url }}">Projects</a>
  <a class="btn btn-outline-secondary btn-sm" href="https://github.com/SPkHz">GitHub</a>
</div>

## Featured projects

{% assign featured = site.data.projects | where: "featured", true %}
{% if featured.size == 0 %}
{% assign featured = site.data.projects | slice: 0, 3 %}
{% endif %}

<div class="row about-featured">
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
        <div class="project-tags">
          {% for t in p.tags %}
            <span class="tag">{{ t }}</span>
          {% endfor %}
        </div>
        {% endif %}

        <div class="d-flex flex-wrap" style="gap: .5rem;">
          {% if p.view and p.view != "" %}<a class="btn btn-sm btn-primary" href="{{ p.view }}">View</a>{% endif %}
          {% if p.source and p.source != "" %}<a class="btn btn-sm btn-outline-secondary" href="{{ p.source }}">Source</a>{% endif %}
        </div>
      </div>
    </div>

  </div>
{% endfor %}
</div>

<p style="margin-top:.75rem;">
  Full list: <a href="{{ '/projects/' | relative_url }}">Projects</a>
</p>
