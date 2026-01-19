---
layout: page
title: news
permalink: /news/
---

{% assign news = site.news | where: "inline", true | sort: "date" | reverse %}
