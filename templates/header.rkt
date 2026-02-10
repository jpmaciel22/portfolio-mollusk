#lang mollusk

<div>
<header>
<h1 class="header">:~ title ~:</h1>
</header>
<hr/>
<nav>
:@ for campo subtitles @:
  <a href=":~ (hash-ref campo "link") ~:"> :~ (hash-ref campo "nome") ~: </a>|
:@ end @:
</nav>
<hr/>
</div>
