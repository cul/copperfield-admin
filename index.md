---
layout: default
viewer: admin
title: Admin Mode
manifests:
  - name: 'Part 1'
    src:  'https://derivativo-3.library.columbia.edu/iiif/2/presentation/10.7916/d8-fcng-k085/manifest.json'
  - name: 'Part 2'
    src:  'https://derivativo-3.library.columbia.edu/iiif/2/presentation/10.7916/d8-99q5-rq86/manifest.json'
---

{% include mirador/annotation_admin.html viewer=page.viewer manifests=page.manifests %}

{% comment %}
manifests:
  - name: 'Part 1'
    src:  'iiif/d8-fcng-k085/manifest.json'
  - name: 'Part 2'
    src:  'iiif/d8-99q5-rq86/manifest.json'
{% endcomment %}
