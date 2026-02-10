#lang mollusk

<div>
<hr />
<nav>
:@ for sub subtitles @:
:@ for campo sub @:
<a href=":~ (hash-ref campo 'link) ~:"> :~ (hash-ref campo 'nome) ~: </a>
:@ end @:
:@ end @:
</nav
<hr />
</div>
