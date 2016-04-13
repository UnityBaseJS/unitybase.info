{% set indexpage=_.find(site.pages.data, {layout : 'index', lang: page.lang}) %}
<header id="banner">
  <div class="inner">
    <h2 id="banner-title">{{ indexpage.subtitle }}</h2>
    <div id="banner-start">
      <span id="banner-start-command">Admin UI live demo</span><a id="banner-start-link" href="docs/"><i class="fa fa-arrow-right"></i></a>
    </div>
    <div id="banner-share">{{ partial('partial/share') }}</div>
  </div>
</header>
<div id="content-wrap">
  <div class="wrapper">
    <div class="inner">
      {{ indexpage.content }}
      <div id="intro-get-started-wrap">
        <a href="docs/" id="intro-get-started-link">{{ __('index.get_started') }}</a>
      </div>
    </div>
  </div>
</div>