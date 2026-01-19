---
layout: page
title: news
permalink: /news/
---

{% assign news = site.news | where_exp: "item", "item.show_on_home != false" | sort: "date" | reverse %}
