{% set indexpage=_.find(site.pages.data, {layout : 'index', lang: page.lang}) %}
<div id="banner">
  <div class="inner">
    <h2 id="banner-title">{{ indexpage.subtitle }}</h2>
    <!--div id="banner-start">
      <span id="banner-start-command">Admin UI live demo</span><a id="banner-start-link" href="docs/"><i class="fa fa-arrow-right"></i></a>
    </div-->
    <div id="banner-share">{{ partial('partial/share') }}</div>
  </div>
</div>
{{ indexpage.content }}