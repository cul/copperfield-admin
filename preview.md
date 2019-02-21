---
layout: default
viewer: zen
title: Preview Mode
manifests:
  - name: 'Part 1'
    src:  'https://derivativo-3.library.columbia.edu/iiif/2/presentation/10.7916/d8-fcng-k085/manifest.json'
  - name: 'Part 2'
    src:  'https://derivativo-3.library.columbia.edu/iiif/2/presentation/10.7916/d8-99q5-rq86/manifest.json'
---

{% include mirador/zen_viewer.html viewer=page.viewer manifests=page.manifests %}
