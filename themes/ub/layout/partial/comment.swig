{% if page.comments && config.disqus_shortname %}
<section id="comments">
  <div id="disqus_thread"></div>
</section>
<script>
    var disqus_shortname = '{{ config.disqus_shortname }}';
    var disqus_url = '{{ url }}';
    var disqus_title = {{ JSON.stringify(page.title) }};

    var disqus_config = function () {
        this.page.url = '{{ page.permalink }}';
        this.page.identifier = '{{ page.path }}';
	this.language = '{{ disqus_lang() }}';
    };
    (function() {
        var d = document, s = d.createElement('script');
        s.src = '//unitybase.disqus.com/embed.js';
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
{% endif %}