---
layout: default
viewer: zen
title: Preview Mode
manifests:
- name: 'Part 1'
  src:  'iiif/d8-fcng-k085/manifest.json'
- name: 'Part 2'
  src:  'iiif/d8-99q5-rq86/manifest.json'
---

{% include mirador/zen_viewer.html viewer=page.viewer manifests=page.manifests %}
